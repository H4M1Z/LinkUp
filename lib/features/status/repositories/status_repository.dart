// ignore_for_file: public_member_api_docs, sort_constructors_first, use_build_context_synchronously
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:gossip_go/models/status_model.dart';
import 'package:gossip_go/models/user_model.dart';
import 'package:gossip_go/repositories/firebase_storage_repo.dart';
import 'package:gossip_go/utils/common_functions.dart';
import 'package:uuid/uuid.dart';

final statusRepositoryProvider = Provider<StatusRepository>((ref) {
  return StatusRepository(
      fireStore: FirebaseFirestore.instance,
      auth: FirebaseAuth.instance,
      ref: ref);
});

class StatusRepository {
  static const _usersCollection = 'users';
  static const _statusCollection = 'status';
  final FirebaseFirestore fireStore;
  final FirebaseAuth auth;
  final ProviderRef ref;
  StatusRepository({
    required this.fireStore,
    required this.auth,
    required this.ref,
  });

  void uploadStatus({
    required BuildContext context,
    required String username,
    required String profilePicture,
    required String phoneNumber,
    required File statusImage,
  }) async {
    try {
      /**
       * the status should be visible to our contacts and if we a re added in theri contacts, we need the contacts of the user , we need to get all the users from firestore with that phone number(status uploader) in the users chat list, add the, in a list so it can be added to a status model, them we will chech if there is a status already present we will add the new status(image) to that list other wise we will add o status(image) 
       */

      var statusId = const Uuid().v1();
      var uid = auth.currentUser!.uid;
      var currentUser = GetIt.I<UserModel>();
      //we are going to store the status in the status folder and with the status and usr id
      var imageUrl =
          await ref.read(firebaseStorageRepositoryProvider).saveFileToStorage(
                path: '/status/$statusId$uid',
                file: statusImage,
              );
      List<Contact> contacts = [];
      if (await FlutterContacts.requestPermission()) {
        //this will fetch us the contacts with all the properties if we set it to false it will return an empty string or a null
        contacts = await FlutterContacts.getContacts(withProperties: true);
      }
      List<String> visibleToUids = [];
      for (var i = 0; i < contacts.length; i++) {
        if (contacts[i].phones.isNotEmpty) {
          var userData = await fireStore
              .collection(_usersCollection)
              .where(
                'phoneNumber',
                isEqualTo: getPhoneNumber(
                  number: contacts[i].phones[0].number,
                ),
              )
              .get();
          if (userData.docs.isNotEmpty) {
            var user = UserModel.fromMap(userData.docs[0].data());
            if (visibleToUids.contains(user.uid) == false &&
                user.uid != currentUser.uid) {
              visibleToUids.add(user.uid);
            }
          }
        }
      }
      List<String> statusImageUrls = [];
      //if a status already exists then we will add the status ,
      var userStatuses = await fireStore
          .collection(_statusCollection)
          .where(
            'uid',
            isEqualTo: auth.currentUser!.uid,
          )
          // we can also get the last 24 hre statuses like this
          // .where(
          //   'created',
          //   isLessThan: DateTime.now().add(
          //     const Duration(
          //       hours: 24,
          //     ),
          //   ),
          // )
          .get();

      if (userStatuses.docs.isNotEmpty) {
        //we are getting the already existing status and then adding the new status to the list of statuses, and the status will be at the first index of the docs,os we donot iterate the whole list
        var status = StatusModel.fromMap(userStatuses.docs[0].data());
        statusImageUrls = status.photosUrl;
        statusImageUrls.add(imageUrl);
        //now that we have added the new status, we need to update it on the firestore also, so first we will get the doc where the list is stored and then update the list of statuses
        fireStore
            .collection(_statusCollection)
            .doc(userStatuses.docs[0].id)
            .update({
          'photosUrl': statusImageUrls,
        });
        log('status uplaoded');
        return;
      } else {
        statusImageUrls = [imageUrl];
      }

      var newStatus = StatusModel(
          uid: uid,
          userName: username,
          phoneNumber: phoneNumber,
          photosUrl: statusImageUrls,
          createdTime: DateTime.now(),
          profilePic: profilePicture,
          statusId: statusId,
          visibleTo: visibleToUids);
      await fireStore
          .collection(_statusCollection)
          .doc(statusId)
          .set(newStatus.toMap());
      log('status uploaded');
    } catch (e) {
      // showSnackBar(context: context, data: e.toString());
      log(e.toString());
    }
  }

  // this function will get all the statuses to Show
  Future<List<StatusModel>> getStatuses({
    required BuildContext context,
  }) async {
    List<StatusModel> statuses = [];

    try {
      List<Contact> contacts = [];
      if (await FlutterContacts.requestPermission()) {
        //this will fetch us the contacts with all the properties if we set it to false it will return an empty string or a null
        contacts = await FlutterContacts.getContacts(withProperties: true);

        for (var i = 0; i < contacts.length; i++) {
          // we will check if there is any phone Number in the Status Collection that the users contatcs Consists of, becoz we want to show the statuses of the other user that are in the users contacts, and we will get the statuses that were posted within the 24 hrs
          if (contacts[i].phones.isNotEmpty) {
            var userStatuses = await fireStore
                .collection(_statusCollection)
                .where(
                  'phoneNumber',
                  isEqualTo: getPhoneNumber(
                    number: contacts[i].phones[0].number,
                  ),
                )
                .where(
                  'createdTime',
                  isGreaterThan: DateTime.now()
                      .subtract(
                        const Duration(
                          hours: 24,
                        ),
                      )
                      .millisecondsSinceEpoch,
                )
                .get();

            for (var statusDoc in userStatuses.docs) {
              //we will iterate through whole docs and get the statuses of all the other users
              var otherUser = StatusModel.fromMap(statusDoc.data());
              //now we will check that if the other user has added the current user in their contact list only then we will show their status to the current user
              if (otherUser.visibleTo.contains(auth.currentUser!.uid)) {
                bool isAlreadyPresent = false;
                for (var element in statuses) {
                  if (element.phoneNumber == otherUser.phoneNumber) {
                    isAlreadyPresent = true;
                  }
                }
                if (!isAlreadyPresent) {
                  statuses.add(otherUser);
                }
              }
            }
          }
        }
        log('statuses fetched');
      }
    } catch (e) {
      showSnackBar(context: context, data: e.toString());
    }
    return statuses;
  }

  Future<StatusModel?> getUserStatus() async {
    var firesStoreStatus = await fireStore
        .collection(_statusCollection)
        .where('phoneNumber',
            isEqualTo: FirebaseAuth.instance.currentUser!.phoneNumber)
        .where('createdTime',
            isGreaterThan: DateTime.now()
                .subtract(
                  const Duration(
                    hours: 24,
                  ),
                )
                .millisecondsSinceEpoch)
        .get();
    StatusModel? status;
    for (var userStatus in firesStoreStatus.docs) {
      status = StatusModel.fromMap(userStatus.data());
    }
    log(status?.userName ?? 'No status');
    return status;
  }
}
