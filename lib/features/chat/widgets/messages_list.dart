import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gossip_go/features/chat/controller/chat_notifier.dart';
import 'package:gossip_go/features/chat/widgets/my_message_card.dart';
import 'package:gossip_go/features/chat/widgets/sender_message_card.dart';
import 'package:gossip_go/features/providers/message_reply_provider/model/message_reply_model.dart';
import 'package:gossip_go/features/providers/message_reply_provider/provider/message_reply_provider.dart';
import 'package:gossip_go/models/message_model.dart';
import 'package:intl/intl.dart';

class MessagesList extends ConsumerWidget {
  const MessagesList({
    super.key,
    required this.itemCount,
    required this.messages,
    required this.receiverUserId,
    required this.isGroupChat,
  });
  final int itemCount;
  final List<MessageModel> messages;
  final String receiverUserId;
  final bool isGroupChat;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView.builder(
      controller: ref.read(chatNotifierProvider.notifier).chatScrollController,
      itemCount: itemCount,
      itemBuilder: (context, index) {
        var messageData = messages[index];
        //if the message is not seen and the receiver user is us then the message will be seeen by us and we will update the message to seen adn we will provide the iseen to only my message card because ti optiion is only for the sender messages  not for the receiver messages
        if (messageData.receiverId == FirebaseAuth.instance.currentUser!.uid &&
            !messageData.isSeen) {
          ref.read(chatNotifierProvider.notifier).setChatMessageSeen(
              context: context,
              receiverUserId: receiverUserId,
              messageId: messageData.messageId);
        }
        if (messageData.senderId == FirebaseAuth.instance.currentUser!.uid) {
          return MyMessageCard(
            messageType: messageData.messageType,
            message: messageData.message,
            date: DateFormat("h:mma").format(messageData.timeSent),
            repliedText: messageData.replyText,
            repliedMessageType: messageData.repliedMessageType,
            userName: 'You',
            onRightSwipe: (details) {
              ref.read(messageReplyProvider.notifier).onMessageSwipe(
                    messageReply: MessageReply(
                      message: messageData.message,
                      isMe: true,
                      messageType: messageData.messageType,
                      messageSenderName: messageData.senderName,
                    ),
                  );
            },
            isSeen: messageData.isSeen,
          );
        }
        return SenderMessageCard(
          messageType: messageData.messageType,
          message: messageData.message,
          date: DateFormat("h:mma").format(messageData.timeSent),
          repliedText: messageData.replyText,
          repliedMessageType: messageData.repliedMessageType,
          receiverUserName: messageData.repliedTo,
          onRightSwipe: (details) {
            ref.read(messageReplyProvider.notifier).onMessageSwipe(
                  messageReply: MessageReply(
                    message: messageData.message,
                    isMe: false,
                    messageType: messageData.messageType,
                    messageSenderName: messageData.senderName,
                  ),
                );
          },
          isGroupChat: isGroupChat,
          // this field will be used to identify which user send the message in the group chat
          senderUserName: messageData.senderName,
        );
      },
    );
  }
}
