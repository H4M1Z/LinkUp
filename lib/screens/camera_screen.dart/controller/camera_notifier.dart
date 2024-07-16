import 'dart:developer';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gossip_go/features/auth/controller/auth_controller.dart';
import 'package:gossip_go/features/chat/respositories/chat_repository.dart';
import 'package:gossip_go/screens/camera_screen.dart/controller/camera_states.dart';
import 'package:gossip_go/screens/camera_screen.dart/view/confirm_picture_screen.dart';
import 'package:gossip_go/utils/messages_enum.dart';

final cameraNotifierProvider =
    AutoDisposeNotifierProvider<CameraNotifier, CameraStates>(
        CameraNotifier.new);

class CameraNotifier extends AutoDisposeNotifier<CameraStates> {
  late CameraController controller;
  late Future<void> initializeControllerFuture;
  final selectedUsersIndex = <int>[];
  final receiverUsers = <String>[];
  @override
  CameraStates build() {
    return CameraInitialState();
  }

  void initialize(CameraDescription camera) {
    state = CameraLoadingState();
    controller = CameraController(
      // Get a specific camera from the list of available cameras.
      camera,
      // Define the resolution to use.
      ResolutionPreset.medium,
    );
    // Next, initialize the controller. This returns a Future.
    initializeControllerFuture = controller.initialize();
    state = CameraLoadedState();
  }

  void sendPicture({
    required BuildContext context,
    required File file,
  }) {
    ref.read(userProvider).whenData(
      (senderUser) {
        log('users seletecd : ${receiverUsers.length}');
        for (var i = 0; i < receiverUsers.length; i++) {
          ref.read(chatRepositoryProvider).sendFileMessage(
              context: context,
              file: file,
              receiverUserId: receiverUsers[i],
              senderUserData: senderUser!,
              ref: ref,
              messageType: MessageEnum.image,
              messageReply: null,
              isGroupChat: false);
        }
        Navigator.pop(context);
      },
    );
  }

  void takePicture(BuildContext context) async {
    try {
      // Ensure that the camera is initialized.
      await initializeControllerFuture;

      // Attempt to take a picture and get the file `image`
      // where it was saved.
      final image = await controller.takePicture();

      if (!context.mounted) return;

      // If the picture was taken, display it on a new screen.
      Navigator.popAndPushNamed(
        context,
        ConfirmPicutureScreen.pageName,
        arguments: File(image.path),
      );
    } catch (e) {
      // If an error occurs, log the error to the console.
      print(e);
    }
  }

  void onTileTap(int index, String receiverUid) {
    state = CameraLoadingState();
    if (selectedUsersIndex.contains(index)) {
      selectedUsersIndex.remove(index);
      receiverUsers.remove(receiverUid);
    } else {
      selectedUsersIndex.add(index);
      receiverUsers.add(receiverUid);
    }
    state = CameraLoadedState();
  }
}
