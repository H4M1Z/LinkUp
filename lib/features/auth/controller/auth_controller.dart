import 'dart:developer';
import 'dart:io';

import 'package:country_picker/country_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gossip_go/features/auth/controller/auth_states.dart';
import 'package:gossip_go/features/auth/repo/auth_repo.dart';
import 'package:gossip_go/models/user_model.dart';
import 'package:gossip_go/utils/common_functions.dart';

final authControllerProvider = NotifierProvider<AuthController, AuthStates>(
  AuthController.new,
);

final userProvider = FutureProvider(
  (ref) {
    final authController = ref.watch(authControllerProvider.notifier);
    return authController.getCurrentUserData();
  },
);

final class AuthController extends Notifier<AuthStates> {
  final loginFieldController = TextEditingController();
  final userNameController = TextEditingController();
  static const _errorMessage = 'Something went wrong';
  String countryCode = '';
  File? image;
  late AuthRepository _authRepository;
  @override
  AuthStates build() {
    _authRepository = ref.read(authRepositoryProvider);
    return AuthInitialState();
  }

  Future<UserModel?> getCurrentUserData() async {
    var user = await _authRepository.getCurrentUser();
    return user;
  }

  void signInWithPhoneNumber({required BuildContext context}) async {
    try {
      state = AuthLoadingState();
      if (countryCode.isNotEmpty && loginFieldController.text.isNotEmpty) {
        var phoneNumber = loginFieldController.text.trim();
        log('$countryCode$phoneNumber');
        _authRepository.signInWithPoneNumber(
            context: context, phoneNumber: '$countryCode$phoneNumber');
        state = const AuthLoadedState();
      }
    } catch (e) {
      state = const AuthErrorState(message: _errorMessage);
    }
  }

  void onPickCountryTap(BuildContext context) {
    state = AuthLoadingState();
    showCountryPicker(
      context: context,
      onSelect: (value) {
        countryCode = '+${value.phoneCode}';
        state = const AuthLoadedState();
      },
    );
  }

  void verifyOtp(
      {required BuildContext context,
      required,
      required String verificationId,
      required String userOtp}) {
    try {
      state = AuthLoadingState();
      _authRepository
          .veriftyOtp(
              verificationId: verificationId,
              context: context,
              userOtp: userOtp)
          .then(
            (value) => state = const AuthLoadedState(),
          );
    } catch (e) {
      showSnackBar(context: context, data: e.toString());
    }
  }

  void pickImage({required BuildContext context}) async {
    state = AuthLoadingState();
    image = await pickImageFromGallery(context: context);
    state = const AuthLoadedState();
  }

  void saveUserInfoToFireStore({required BuildContext context}) {
    state = AuthLoadingState();
    _authRepository.saveUserDataToFireBaseFirestore(
        userName: userNameController.text.trim(),
        profilePic: image,
        ref: ref,
        context: context);
    state = const AuthLoadedState();
  }

//this function will tell us wether a user is online or offline and we will continouly listen to the stream so the data also updates on other devices, otherwise we woukd have to send the function from every device to check that if other person is online or off line
  Stream<UserModel> userDataById({required String userId}) {
    return ref.read(authRepositoryProvider).getUserData(userId: userId);
  }

  void setUserStatus({required bool isOnline}) =>
      ref.read(authRepositoryProvider).setUserStatus(isOnline: isOnline);
}
