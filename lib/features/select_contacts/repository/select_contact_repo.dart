// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gossip_go/features/chat/view/mobile_chat_screen.dart';
import 'package:gossip_go/models/user_model.dart';
import 'package:gossip_go/utils/common_functions.dart';

final selectRpositoryProvider = Provider((ref) {
  return SelectContactRepository(
    firestore: FirebaseFirestore.instance,
  );
});

class SelectContactRepository {
  final FirebaseFirestore firestore;

  SelectContactRepository({
    required this.firestore,
  });

  Future<List<Contact>> getContacts() async {
    List<Contact> contacts = [];
    try {
      if (await FlutterContacts.requestPermission()) {
        //this will fetch us the contacts with all the properties if we set it to false it will return an empty string or a null
        contacts = await FlutterContacts.getContacts(withProperties: true);
      }

      for (var i = 0; i < contacts.length; i++) {
        if (contacts[i].phones.isNotEmpty) {
          String phoneNumber = '';
          if (contacts[i].phones[0].number.startsWith('0')) {
            log('number starts with zero');
            phoneNumber =
                contacts[i].phones[0].number.replaceFirst(RegExp('0'), '+92');
            phoneNumber = phoneNumber.replaceAll(' ', '');
          } else {
            phoneNumber = contacts[i].phones[0].number.replaceAll(' ', '');
          }
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return contacts;
  }

  checkUser(
      {required Contact selectedContact, required BuildContext context}) async {
    try {
      const userNotFoundMessage = 'User doesn\'t exist on the app';
      var usersCollection = await firestore.collection('users').get();
      bool isFound = false;
      for (var document in usersCollection.docs) {
        var user = UserModel.fromMap(document.data());
        //user can have multiple phone numbers and if we set the with properties attr to fasle in the above func than the number attr here will be an empty string or null
        String phoneNumber =
            getPhoneNumber(number: selectedContact.phones[0].number);
        log('selected number : $phoneNumber');
        if (user.phoneNumber == phoneNumber) {
          isFound = true;
          Navigator.of(context).pushNamed(
            MobileChatScreen.pageName,
            arguments: ChatScreenArguments(
              name: user.name,
              groupOrReceiverId: user.uid,
              profilePic: user.profilePic,
              isgroupChat: false,
            ),
          );
        }
      }
      if (!isFound) {
        showSnackBar(context: context, data: userNotFoundMessage);
      }
    } catch (e) {
      showSnackBar(context: context, data: e.toString());
    }
  }
}

class ChatScreenArguments {
  final String name, groupOrReceiverId, profilePic;
  final bool isgroupChat;
  const ChatScreenArguments({
    required this.name,
    required this.groupOrReceiverId,
    required this.profilePic,
    required this.isgroupChat,
  });
}
