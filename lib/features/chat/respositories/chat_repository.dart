// ignore_for_file: use_build_context_synchronously
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gossip_go/features/providers/message_reply_provider/model/message_reply_model.dart';
import 'package:gossip_go/models/chat_contact_model.dart';
import 'package:gossip_go/models/group_model.dart';
import 'package:gossip_go/models/message_model.dart';
import 'package:gossip_go/models/user_model.dart';
import 'package:gossip_go/repositories/firebase_storage_repo.dart';
import 'package:gossip_go/utils/common_functions.dart';
import 'package:gossip_go/utils/messages_enum.dart';
import 'package:uuid/uuid.dart';

final chatRepositoryProvider = Provider(
  (ref) => ChatRepository(
    firestore: FirebaseFirestore.instance,
    auth: FirebaseAuth.instance,
  ),
);

class ChatRepository {
  static const _usersCollection = 'users';
  static const _chatsCollection = 'chats';
  static const _messagesCollection = 'messages';
  static const _groupsCollection = 'groups';
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;
  ChatRepository({
    required this.firestore,
    required this.auth,
  });

  void _saveDataToContactsSubCollection({
    required UserModel senderUser,
    required UserModel? receiverUser,
    required String message,
    required String groupOrReceiverId,
    required DateTime dateTime,
    required bool isGroupChat,
  }) async {
    //we are going to store data based on wether it is a group chat or a single chat
    if (isGroupChat) {
      //we will update the data of last message and time with the last message sender
      firestore.collection(_groupsCollection).doc(groupOrReceiverId).update({
        'lastMessage': message,
        'timeSent': dateTime.millisecondsSinceEpoch
      });
    } else {
      /**
    * Basically we will have to save the data to two locations becoz we want the last message to be displayed on the scrren of the reciver and on our screen as well 
    * For updating the last message to be shown on the recievers phone the path will be -> users/receiverId/chats/senderId/set data
    * For updating the last message to be shown on the our phone the path will be -> users/senderId/chats/receiverId/set data
    */
      //for receiver
      var receiverUserChat = ChatContactModel(
          name: senderUser.name,
          profilePic: senderUser.profilePic,
          time: dateTime,
          contactId: senderUser.uid,
          lastMessage: message);
      await firestore
          .collection(_usersCollection)
          .doc(groupOrReceiverId)
          .collection(_chatsCollection)
          .doc(senderUser.uid)
          .set(receiverUserChat.toMap());

      //for sender
      var senderUserChat = ChatContactModel(
          name: receiverUser!.name,
          profilePic: receiverUser.profilePic,
          time: dateTime,
          contactId: receiverUser.uid,
          lastMessage: message);
      await firestore
          .collection(_usersCollection)
          .doc(senderUser.uid)
          .collection(_chatsCollection)
          .doc(receiverUser.uid)
          .set(senderUserChat.toMap());
    }
  }

  void sendTextMessage({
    required BuildContext context,
    required String message,
    required UserModel sender,
    required String groupOrReceiverId,
    MessageReply? messageReply,
    required bool isGroupChat,
  }) async {
    try {
      var timeStamp = DateTime.now();
      UserModel? receiverUser;
      if (!isGroupChat) {
        var receiverUserMap = await firestore
            .collection(_usersCollection)
            .doc(groupOrReceiverId)
            .get();
        receiverUser = UserModel.fromMap(receiverUserMap.data()!);
      }

      //this will create a unique message id based on time
      var messageId = const Uuid().v1();
      //now we will create a function to send and save the message to firestore for the sender and the receiver as well, and we will store this in th chat subCollection which will be displayed on the layout screen
      _saveDataToContactsSubCollection(
          senderUser: sender,
          receiverUser: receiverUser,
          message: message,
          dateTime: timeStamp,
          groupOrReceiverId: groupOrReceiverId,
          isGroupChat: isGroupChat);
      //this function will add the message to both the sender and the receiver messages collection
      _saveMessageToMessageSubCollection(
        messageId: messageId,
        groupOrReceiverId: groupOrReceiverId,
        text: message,
        timeSent: timeStamp,
        messageType: MessageEnum.text,
        receiverUserName: receiverUser?.name,
        senderUserName: sender.name,
        messageReply: messageReply,
        repliedMessageType:
            messageReply == null ? MessageEnum.text : messageReply.messageType,
        isGroupChat: isGroupChat,
      );
    } catch (e) {
      showSnackBar(context: context, data: 'Message was not sent');
    }
  }

  void _saveMessageToMessageSubCollection({
    required String groupOrReceiverId,
    required String text,
    required DateTime timeSent,
    required String messageId,
    required String senderUserName,
    required String? receiverUserName,
    required MessageEnum messageType,
    required MessageReply? messageReply,
    required MessageEnum repliedMessageType,
    required bool isGroupChat,
  }) async {
    var message = MessageModel(
      senderId: auth.currentUser!.uid,
      receiverId: groupOrReceiverId,
      senderName: senderUserName,
      message: text,
      messageType: messageType,
      timeSent: timeSent,
      messageId: messageId,
      isSeen: false,
      replyText: messageReply == null ? '' : messageReply.message,
      repliedTo: messageReply == null
          ? ''
          : messageReply.isMe
              ? senderUserName
              : receiverUserName ?? '',
      repliedMessageType: repliedMessageType,
    );
    if (isGroupChat) {
      await firestore
          .collection(_groupsCollection)
          .doc(groupOrReceiverId)
          .collection(_chatsCollection)
          .doc(messageId)
          .set(message.toMap());
    } else {
      // this will be the message that is going to be saved on our database and we will have to create a similar one for the receiver also

      //the path fo us will be users/sender/receiever/messages/messageId/message
      await firestore
          .collection(_usersCollection)
          .doc(auth.currentUser!.uid)
          .collection(_chatsCollection)
          .doc(groupOrReceiverId)
          .collection(_messagesCollection)
          .doc(messageId)
          .set(message.toMap());
      //the path fot receiver will be users/receiver/sender/messages/messageId/message
      await firestore
          .collection(_usersCollection)
          .doc(groupOrReceiverId)
          .collection(_chatsCollection)
          .doc(auth.currentUser!.uid)
          .collection(_messagesCollection)
          .doc(messageId)
          .set(message.toMap());
    }
  }

  Stream<List<ChatContactModel>> getChatContacts() {
    //we could use map but in this we are going too convert all the chats documents to our model and we will have to connect to firestore so we will use the async Map
    var currentUser = auth.currentUser!;
    return firestore
        .collection(_usersCollection)
        .doc(currentUser.uid)
        .collection(_chatsCollection)
        .snapshots()
        .map(
      (chats) {
        List<ChatContactModel> listOfContacts = [];
        // we are getting the documnet snapshot and from that docSnapshot we will convert to chat model
        for (var doc in chats.docs) {
          var chatContact = ChatContactModel.fromMap(doc.data());
          listOfContacts.add(
            ChatContactModel(
              name: chatContact.name,
              profilePic: chatContact.profilePic,
              time: chatContact.time,
              contactId: chatContact.contactId,
              lastMessage: chatContact.lastMessage,
            ),
          );
        }
        return listOfContacts;
      },
    );
  }

  //this will get the groupChats
  Stream<List<GroupModel>> getGroupChats() {
    //we could use map but in this we are going too convert all the chats documents to our model
    var currentUser = auth.currentUser!;
    return firestore.collection(_groupsCollection).snapshots().map(
      (groups) {
        List<GroupModel> listOfGroups = [];
        // we are getting the documnet snapshot and from that docSnapshot we will convert to chat model
        for (var doc in groups.docs) {
          var group = GroupModel.fromMap(doc.data());

          //now we will check if the user is in this group or not
          if (group.groupMemberIds.contains(currentUser.uid)) {
            listOfGroups.add(group);
          }
        }
        return listOfGroups;
      },
    );
  }

  Future<GroupModel> groupDataById({required String groupId}) async {
    var groupinfo =
        await firestore.collection(_groupsCollection).doc(groupId).get();
    var group = GroupModel.fromMap(groupinfo.data()!);
    return group;
  }

  Stream<List<MessageModel>> getContactMessages({required String receiverId}) {
    var currentUser = auth.currentUser!;
    return firestore
        .collection(_usersCollection)
        .doc(currentUser.uid)
        .collection(_chatsCollection)
        .doc(receiverId)
        .collection(_messagesCollection)
        .orderBy('timeSent')
        .snapshots()
        .map(
      (messages) {
        List<MessageModel> chatMessages = [];
        for (var message in messages.docs) {
          var chatMessage = MessageModel.fromMap(message.data());
          chatMessages.add(chatMessage);
        }
        log(chatMessages.length.toString());
        return chatMessages;
      },
    );
  }

  //tis function will get us the messages of the group
  Stream<List<MessageModel>> getGroupMessages({required String groupId}) {
    return firestore
        .collection(_groupsCollection)
        .doc(groupId)
        .collection(_chatsCollection)
        .orderBy('timeSent')
        .snapshots()
        .map(
      (messages) {
        List<MessageModel> chatMessages = [];
        for (var message in messages.docs) {
          var chatMessage = MessageModel.fromMap(message.data());
          chatMessages.add(chatMessage);
        }
        return chatMessages;
      },
    );
  }

  void sendFileMessage(
      {required BuildContext context,
      required File file,
      required String receiverUserId,
      required UserModel senderUserData,
      required NotifierProviderRef ref,
      required MessageEnum messageType,
      required MessageReply? messageReply,
      required bool isGroupChat}) async {
    try {
      var timeStamp = DateTime.now();
      var messageId = const Uuid().v1();
      var imageUrl = await ref
          .read(firebaseStorageRepositoryProvider)
          .saveFileToStorage(
              path:
                  'chat/$messageType/${senderUserData.uid}/$receiverUserId/${file.hashCode}',
              file: file);
      UserModel? receiverUserData;
      if (!isGroupChat) {
        var receiverUserMap = await firestore
            .collection(_usersCollection)
            .doc(receiverUserId)
            .get();
        receiverUserData = UserModel.fromMap(receiverUserMap.data()!);
      }

      //we need to show the text differently here based on the message type so according to the message type we will send the textMessage
      var message = switch (messageType) {
        MessageEnum.image => '\u{1F4F7}Photo',
        MessageEnum.video => '\u{1F4F9}Video',
        MessageEnum.audio => '\u{1F399}Audio',
        _ => 'text'
      };
      _saveDataToContactsSubCollection(
        senderUser: senderUserData,
        receiverUser: receiverUserData,
        message: message,
        dateTime: timeStamp,
        isGroupChat: isGroupChat,
        groupOrReceiverId: receiverUserId,
      );
      _saveMessageToMessageSubCollection(
        groupOrReceiverId: receiverUserId,
        text: imageUrl,
        timeSent: timeStamp,
        messageId: messageId,
        senderUserName: senderUserData.name,
        receiverUserName: receiverUserData?.name,
        messageType: messageType,
        messageReply: messageReply,
        repliedMessageType:
            messageReply == null ? MessageEnum.text : messageReply.messageType,
        isGroupChat: isGroupChat,
      );
    } catch (e) {
      showSnackBar(context: context, data: e.toString());
      log(e.toString());
    }
  }

  // this function will be different form the text and other file messages coz we can already get the url form the gif so we donot need to store it in the storage and then store it in firestore we will directly store it to firestore so we will make a diff func for this
  void sendGifMessage({
    required BuildContext context,
    required String gifUrl,
    required UserModel sender,
    required String messageReceiverId,
    required MessageReply? messageReply,
    required bool isGroupChat,
  }) async {
    try {
      var timeStamp = DateTime.now();
      UserModel? receiverUser;
      if (!isGroupChat) {
        var receiverUserMap = await firestore
            .collection(_usersCollection)
            .doc(messageReceiverId)
            .get();
        receiverUser = UserModel.fromMap(receiverUserMap.data()!);
      }
      //this will create a unique message id based on time
      var messageId = const Uuid().v1();
      //now we will create a function to send and save the gif to firestore for the sender and the receiver as well, and we will store this in th chat subCollection which will be displayed on the layout screen
      _saveDataToContactsSubCollection(
          senderUser: sender,
          receiverUser: receiverUser,
          message: 'GIF',
          dateTime: timeStamp,
          groupOrReceiverId: messageReceiverId,
          isGroupChat: isGroupChat);
      //this function will add the gifs to both the sender and the receiver messages collection
      _saveMessageToMessageSubCollection(
        messageId: messageId,
        groupOrReceiverId: messageReceiverId,
        text: gifUrl,
        timeSent: timeStamp,
        messageType: MessageEnum.gif,
        receiverUserName: receiverUser?.name,
        senderUserName: sender.name,
        messageReply: messageReply,
        repliedMessageType:
            messageReply == null ? MessageEnum.text : messageReply.messageType,
        isGroupChat: isGroupChat,
      );
    } catch (e) {
      showSnackBar(context: context, data: 'Gif was not sent');
    }
  }

  void setChatMessageToSeen({
    required BuildContext context,
    required String receiverUserId,
    required String messageId,
  }) async {
    try {
      //the path fo us will be users/sender/receiever/messages/messageId/message
      await firestore
          .collection(_usersCollection)
          .doc(auth.currentUser!.uid)
          .collection(_chatsCollection)
          .doc(receiverUserId)
          .collection(_messagesCollection)
          .doc(messageId)
          .update(
        {
          'isSeen': true,
        },
      );
      //the path fot receiver will be users/receiver/sender/messages/messageId/message
      await firestore
          .collection(_usersCollection)
          .doc(receiverUserId)
          .collection(_chatsCollection)
          .doc(auth.currentUser!.uid)
          .collection(_messagesCollection)
          .doc(messageId)
          .update(
        {
          'isSeen': true,
        },
      );
    } catch (e) {
      showSnackBar(context: context, data: e.toString());
    }
  }
}
