// ignore_for_file: public_member_api_docs, sort_constructors_first, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gossip_go/features/call/screens/call_screen.dart';
import 'package:gossip_go/models/call_model.dart';
import 'package:gossip_go/models/group_model.dart';
import 'package:gossip_go/utils/common_functions.dart';

final callRepositoryProvider = Provider<CallRepository>((ref) {
  return CallRepository(
      firestore: FirebaseFirestore.instance, auth: FirebaseAuth.instance);
});

class CallRepository {
  static const _callsCollection = 'calls';
  static const _groupsCollection = 'groups';
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;
  CallRepository({
    required this.firestore,
    required this.auth,
  });

  //this stream will continously check in the calls subcollection that if there is a call with the user id in it so that the call screen will pop up
  Stream<DocumentSnapshot> get callStream => firestore
      .collection(_callsCollection)
      .doc(auth.currentUser!.uid)
      .snapshots();

  void makeCall({
    required BuildContext context,
    required CallModel callerData,
    required CallModel callReceiverData,
  }) async {
    try {
      //first of all we need to store the call information in the call collection with the documnet of the caller id and for the receiver id also so that both will listen to the same stream
      await firestore
          .collection(_callsCollection)
          .doc(callerData.callerId)
          .set(callerData.toMap());
      await firestore
          .collection(_callsCollection)
          .doc(callerData.receiverId)
          .set(callReceiverData.toMap());

      Navigator.of(context).pushNamed(
        CallScreen.pageName,
        arguments: {
          'channelName': callerData.callId,
          'call': callerData,
          'isGroupChat': false,
        },
      );
    } catch (e) {
      showSnackBar(context: context, data: e.toString());
    }
  }

  void endCall({
    required BuildContext context,
    required String callerId,
    required String callReceiverId,
  }) async {
    try {
      //first of all we need to store the call information in the call collection with the documnet of the caller id and for the receiver id also so that both will listen to the same stream
      await firestore.collection(_callsCollection).doc(callerId).delete();
      await firestore.collection(_callsCollection).doc(callReceiverId).delete();
    } catch (e) {
      showSnackBar(context: context, data: e.toString());
    }
  }

  void makeGroupCall({
    required BuildContext context,
    required CallModel callerData,
    required CallModel callReceiverData,
  }) async {
    try {
      //first of all we need to store the call information in the call collection with the documnet of the caller id and for the receiver id also so that both will listen to the same stream
      await firestore
          .collection(_callsCollection)
          .doc(callerData.callerId)
          .set(callerData.toMap());

      //for group call we need to get the ifo of the group
      var groupData = await firestore
          .collection(_groupsCollection)
          .doc(callerData.receiverId)
          .get();

      var group = GroupModel.fromMap(groupData.data()!);

      for (var i = 0; i < group.groupMemberIds.length; i++) {
        await firestore
            .collection(_callsCollection)
            .doc(group.groupMemberIds[i])
            .set(callReceiverData.toMap());
      }

      Navigator.of(context).pushNamed(
        CallScreen.pageName,
        arguments: {
          'channelName': callerData.callId,
          'call': callerData,
          'isGroupChat': true,
        },
      );
    } catch (e) {
      showSnackBar(context: context, data: e.toString());
    }
  }

  void endGroupCall({
    required BuildContext context,
    required String callerId,
    required String callReceiverId,
  }) async {
    try {
      //first of all we need to store the call information in the call collection with the documnet of the caller id and for the receiver id also so that both will listen to the same stream
      await firestore.collection(_callsCollection).doc(callerId).delete();

      var groupData = await firestore
          .collection(_groupsCollection)
          .doc(callReceiverId)
          .get();

      var group = GroupModel.fromMap(groupData.data()!);

      for (var i = 0; i < group.groupMemberIds.length; i++) {
        await firestore
            .collection(_callsCollection)
            .doc(group.groupMemberIds[i])
            .delete();
      }
    } catch (e) {
      showSnackBar(context: context, data: e.toString());
    }
  }
}
