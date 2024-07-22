import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:gossip_go/features/auth/controller/auth_controller.dart';
import 'package:gossip_go/features/call/controller/call_states.dart';
import 'package:gossip_go/features/call/repository/call_repository.dart';
import 'package:gossip_go/models/call_model.dart';
import 'package:gossip_go/models/user_model.dart';
import 'package:uuid/uuid.dart';

final callNotifierProvider =
    NotifierProvider<CallNotifier, CallState>(CallNotifier.new);

class CallNotifier extends Notifier<CallState> {
  @override
  CallState build() {
    return CallInitialState();
  }

  var shouldPop = false;

//this stream will continously check in the calls subcollection that if there is a call with the user id in it so that the call screen will pop up

  Stream<DocumentSnapshot> get callStream =>
      ref.read(callRepositoryProvider).callStream;

  //function to make a call
  void makeCall(
      {required BuildContext context,
      required String callReceiverUid,
      required String callReceiverName,
      required String callReceievrPic,
      required bool isGroupChat}) {
    ref.read(userProvider).whenData(
      (caller) {
        final currentUser = GetIt.I<UserModel>();
        String callId = const Uuid().v1();
        CallModel callerData = CallModel(
            callerId: currentUser.uid,
            callerName: currentUser.name,
            callerPic: currentUser.profilePic,
            receiverId: callReceiverUid,
            receiverName: callReceiverName,
            receiverPic: callReceievrPic,
            callId: callId,
            hasDialed: true,
            isGroupCall: isGroupChat);
        // all the data will be same other than than dialed one
        CallModel callReceiverData = CallModel(
            callerId: currentUser.uid,
            callerName: currentUser.name,
            callerPic: currentUser.profilePic,
            receiverId: callReceiverUid,
            receiverName: callReceiverName,
            receiverPic: callReceievrPic,
            callId: callId,
            hasDialed: false,
            isGroupCall: isGroupChat);
        if (isGroupChat) {
          ref.read(callRepositoryProvider).makeGroupCall(
              context: context,
              callerData: callerData,
              callReceiverData: callReceiverData);
        } else {
          ref.read(callRepositoryProvider).makeCall(
              context: context,
              callerData: callerData,
              callReceiverData: callReceiverData);
        }
        shouldPop = true;
      },
    );
  }

  void endCall({
    required BuildContext context,
    required String callerId,
    required callReceiverId,
    required bool isGroupCall,
  }) {
    if (isGroupCall) {
      ref.read(callRepositoryProvider).endGroupCall(
          context: context, callerId: callerId, callReceiverId: callReceiverId);
    } else {
      ref.read(callRepositoryProvider).endCall(
          context: context, callerId: callerId, callReceiverId: callReceiverId);
    }
  }

  void shouldPopScreen(bool shouldPopScreen) {
    shouldPop = shouldPopScreen;
  }
}
