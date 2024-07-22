// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enough_giphy_flutter/enough_giphy_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:gossip_go/firebase_options.dart';
import 'package:gossip_go/models/user_model.dart';
import 'package:gossip_go/services/database_service.dart';
import 'package:gossip_go/utils/colors.dart';
import 'package:image_picker/image_picker.dart';
import 'package:workmanager/workmanager.dart';

void showSnackBar({required BuildContext context, required String data}) =>
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 1),
        backgroundColor: backgroundColor,
        content: Text(
          data,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );

Future<File?> pickImageFromGallery({required BuildContext context}) async {
  File? image;
  try {
    var pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      image = File(pickedImage.path);
    }
  } catch (e) {
    showSnackBar(context: context, data: e.toString());
  }

  return image;
}

Future<File?> pickVideoFromGallery({required BuildContext context}) async {
  File? vid;
  try {
    var pickedVid = await ImagePicker().pickVideo(source: ImageSource.gallery);
    if (pickedVid != null) {
      vid = File(pickedVid.path);
    }
  } catch (e) {
    showSnackBar(context: context, data: e.toString());
  }

  return vid;
}

Future<GiphyGif?> pickGif({required BuildContext context}) async {
  const apiKey = 'TrhiofgoNm7hestIOjQG3xsGNJDGVTKX';
  GiphyGif? gif;
  try {
    gif = await Giphy.getGif(
      context: context,
      apiKey: apiKey,
    );
  } catch (e) {
    showSnackBar(context: context, data: e.toString());
  }
  return gif;
}

String getPhoneNumber({required String number}) {
  String phoneNumber = '';
  if (number.startsWith('0')) {
    phoneNumber = number.replaceFirst(RegExp('0'), '+92');
    phoneNumber = phoneNumber.replaceAll(' ', '');
    return phoneNumber;
  } else {
    phoneNumber = number.replaceAll(' ', '');
    return phoneNumber;
  }
}

const getAppUsers = 'Get App Users';

@pragma('vm:entry-point')
void callBackDispatcher() {
  Workmanager().executeTask(
    (taskName, inputData) async {
      try {
        const usersCollection = 'users';
        DBHelper db = DBHelper();
        int totalUsers = 0;
        db.getAppUsers().then(
          (value) {
            log('total users in thread func : ${value.length}');
            return totalUsers = value.length;
          },
        );
        await Firebase.initializeApp(options: DefaultFirebaseOptions.android);
        List<UserModel> appUsers = [];
        List<Contact> contacts = [];
        if (await FlutterContacts.requestPermission()) {
          contacts = await FlutterContacts.getContacts(withProperties: true);
        }
        log(contacts.length.toString());
        for (var i = 0; i < contacts.length; i++) {
          if (contacts[i].phones.isNotEmpty) {
            var firestoreUser = await FirebaseFirestore.instance
                .collection(usersCollection)
                .where(
                  'phoneNumber',
                  isEqualTo: getPhoneNumber(
                    number: contacts[i].phones[0].number,
                  ),
                )
                .get();
            if (firestoreUser.docs.isNotEmpty) {
              var user = UserModel.fromMap(firestoreUser.docs[0].data());
              if (user.uid != FirebaseAuth.instance.currentUser!.uid) {
                bool isAlreadyPresent = false;
                for (var element in appUsers) {
                  if (element.uid == user.uid) {
                    isAlreadyPresent = true;
                  }
                }
                if (!isAlreadyPresent) {
                  appUsers.add(user);
                }
              }
            }
          } else {
            log('contact empty');
          }
        }
        ('task completed app users : ${appUsers.length}');
        if (totalUsers != appUsers.length) {
          await db.clearTable();
          if (await db.insertUsers(appUsers)) {
            log('users inserted');
          } else {
            log('users not inserted');
          }
        } else {
          log('total users are same');
        }
      } catch (e) {
        throw Exception(e);
      }
      return true;
    },
  );
}
