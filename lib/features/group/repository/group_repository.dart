import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gossip_go/models/group_model.dart';
import 'package:gossip_go/models/user_model.dart';
import 'package:gossip_go/repositories/firebase_storage_repo.dart';
import 'package:gossip_go/utils/common_functions.dart';
import 'package:uuid/uuid.dart';

final groupRepositoryProvider = Provider<GroupRepository>((ref) {
  return GroupRepository(
    firestore: FirebaseFirestore.instance,
    ref: ref,
  );
});

class GroupRepository {
  static const _groupsCollection = 'groups';
  final FirebaseFirestore firestore;
  final ProviderRef ref;
  GroupRepository({
    required this.firestore,
    required this.ref,
  });

  void createGroup({
    required BuildContext context,
    required String groupName,
    required File groupImage,
    required List<UserModel> selectedContacts,
  }) async {
    try {
      //first we will check if the user with the selected contact is in the app or not
      var currentUser = FirebaseAuth.instance.currentUser!;
      List<String> groupUsersUids = [currentUser.uid];
      List<String> groupMemberNames = [];
      for (var i = 0; i < selectedContacts.length; i++) {
        groupUsersUids.add(selectedContacts[i].uid);
        groupMemberNames.add(selectedContacts[i].name);
      }
      //now we will create a group
      var groupId = const Uuid().v1();
      var groupPic = await ref
          .read(firebaseStorageRepositoryProvider)
          .saveFileToStorage(path: 'group/$groupId', file: groupImage);
      GroupModel group = GroupModel(
        lastMessageSenderId: currentUser.uid,
        groupName: groupName,
        groupId: groupId,
        lastMessage: '',
        groupPic: groupPic,
        groupMemberIds: groupUsersUids,
        groupMemberNames: [...groupMemberNames, 'You'],
        timeSent: DateTime.now(),
      );
      // now we will make a group in the groups collection
      await firestore
          .collection(_groupsCollection)
          .doc(groupId)
          .set(group.toMap());
    } catch (e) {
      // ignore: use_build_context_synchronously
      showSnackBar(context: context, data: e.toString());
    }
  }
}
