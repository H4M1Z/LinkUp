// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gossip_go/features/auth/screens/otp_screen/view/otp_screen.dart';
import 'package:gossip_go/features/auth/screens/user_information_screen/view/user_information_screen.dart';
import 'package:gossip_go/models/user_model.dart';
import 'package:gossip_go/repositories/firebase_storage_repo.dart';
import 'package:gossip_go/screens/mobile_layout_screen/view/mobile_layout_screen.dart';
import 'package:gossip_go/utils/common_functions.dart';

final authRepositoryProvider = Provider(
  (ref) => AuthRepository(
    auth: FirebaseAuth.instance,
    fireStore: FirebaseFirestore.instance,
  ),
);

class AuthRepository {
  static const _usersCollection = 'users';
  final FirebaseAuth auth;
  final FirebaseFirestore fireStore;
  const AuthRepository({required this.auth, required this.fireStore});

  Future<UserModel?> getCurrentUser() async {
    final userData = await fireStore
        .collection(_usersCollection)
        .doc(auth.currentUser?.uid)
        .get();

    UserModel? user;
    if (userData.data() != null) {
      user = UserModel.fromMap(userData.data()!);
    }

    return user;
  }

  Future<void> signInWithPoneNumber(
      {required BuildContext context,
      required String phoneNumber,
      required CameraDescription camera}) async {
    try {
      auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (phoneAuthCredential) async {
          await auth.signInWithCredential(phoneAuthCredential);
          log('phoneCrendential func called');
        },
        verificationFailed: (error) => throw Exception(error.message),
        codeSent: (verificationId, forceResendingToken) {
          Navigator.of(context).pushNamed(OTPScreen.pageName,
              arguments: [verificationId, camera]);
        },
        codeAutoRetrievalTimeout: (verificationId) {},
      );
    } on FirebaseAuthException catch (e) {
      showSnackBar(context: context, data: e.message!);
    }
  }

  Future<void> veriftyOtp({
    required BuildContext context,
    required,
    required String verificationId,
    required String userOtp,
    required CameraDescription camera,
  }) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: userOtp);
      await auth.signInWithCredential(credential);
      Navigator.of(context).pushNamedAndRemoveUntil(
        UserInformationScreen.pageName,
        arguments: camera,
        (route) => false,
      );
    } on FirebaseAuthException catch (e) {
      showSnackBar(context: context, data: e.message!);
    }
  }

  void saveUserDataToFireBaseFirestore(
      {required String userName,
      required File? profilePic,
      required NotifierProviderRef ref,
      required BuildContext context,
      required CameraDescription camera}) async {
    // we have to uplaod the image to firebase storage and it will give us a download url and we need to store it in the firestore we will use the same uid to store it to storage and firestore as well
    try {
      String uid = auth.currentUser!.uid;
      String profileImage =
          await ref.read(firebaseStorageRepositoryProvider).getnoPfp();
      if (profilePic != null) {
        profileImage = await ref
            .read(firebaseStorageRepositoryProvider)
            .saveFileToStorage(path: 'profilePic/$uid', file: profilePic);
      }
      var user = UserModel(
          name: userName,
          uid: uid,
          phoneNumber: auth.currentUser!.phoneNumber!,
          profilePic: profileImage,
          isOnline: true,
          groupIds: []);
      //This will create a users collection if there is not a collection already present and in there it will create a document in which the user data will be stored.
      await fireStore.collection(_usersCollection).doc(uid).set(user.toMap());
      Navigator.of(context).pushNamedAndRemoveUntil(
        MobileLayoutScreen.pageName,
        arguments: camera,
        (route) => false,
      );
    } catch (e) {
      showSnackBar(context: context, data: e.toString());
    }
  }

  //this function will tell us wether a user is online or offline and we will continously listen to the stream so the data also updates on other devices, otherwise we woukd have to send the function from every device to chech that ifother person is online or off line
  Stream<UserModel> getUserData({required String userId}) {
    return fireStore.collection(_usersCollection).doc(userId).snapshots().map(
          (doc) => UserModel.fromMap(doc.data()!),
        );
  }

  //this function will set the user online or offline
  void setUserStatus({required bool isOnline}) async {
    await fireStore
        .collection(_usersCollection)
        .doc(auth.currentUser!.uid)
        .update({
      'isOnline': isOnline,
    });
  }
}
