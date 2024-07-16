import 'dart:developer';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:gossip_go/features/auth/controller/auth_controller.dart';
import 'package:gossip_go/features/auth/controller/auth_states.dart';
import 'package:gossip_go/features/auth/screens/widgets/user_info_screen_text_field.dart';
import 'package:gossip_go/features/auth/screens/widgets/user_profile_image_widget.dart';
import 'package:gossip_go/models/user_model.dart';
import 'package:gossip_go/utils/colors.dart';

class UserInformationScreen extends ConsumerWidget {
  const UserInformationScreen({super.key});
  static const pageName = '/user-information';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var camera =
        ModalRoute.of(context)!.settings.arguments as CameraDescription;
    SchedulerBinding.instance.addPostFrameCallback(
      (timeStamp) {
        ref.watch(userProvider).whenData(
          (user) {
            if (user != null) {
              GetIt.I.registerSingleton<UserModel>(user);
            } else {
              log('user is null');
            }
          },
        );
      },
    );
    void onAddImageTap() =>
        ref.read(authControllerProvider.notifier).pickImage(context: context);
    void saveUserData() {
      ref
          .read(authControllerProvider.notifier)
          .saveUserInfoToFireStore(context: context, camera: camera);
      FocusManager.instance.primaryFocus!.unfocus();
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final height = constraints.maxHeight;
            final width = constraints.maxWidth;
            return Stack(
              children: [
                Column(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Positioned(
                            top: height * 0.1,
                            child: const ProfileImageAvatar(),
                          ),
                          Positioned(
                              top: height * 0.25,
                              right: width * 0.33,
                              child: IconButton(
                                  onPressed: onAddImageTap,
                                  icon: const Icon(Icons.add_a_photo)))
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: Row(
                        children: [
                          Expanded(
                              flex: 2,
                              child: Align(
                                alignment: Alignment.topRight,
                                child: UserInfoScreenTextField(
                                  width: width,
                                ),
                              )),
                          Expanded(
                            flex: 1,
                            child: Align(
                              alignment: Alignment.topCenter,
                              child: IconButton(
                                onPressed: saveUserData,
                                icon: const Icon(
                                  Icons.done,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
                Positioned(
                  top: height * 0.35,
                  left: width * 0.4,
                  child: const UserInfoScreenLoadingWidet(),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}

class UserInfoScreenLoadingWidet extends ConsumerWidget {
  const UserInfoScreenLoadingWidet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var state = ref.watch(authControllerProvider);
    return state is AuthLoadingState
        ? const CircularProgressIndicator(
            color: tabColor,
          )
        : const SizedBox();
  }
}
