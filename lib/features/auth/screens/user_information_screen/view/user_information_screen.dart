import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gossip_go/features/auth/controller/auth_controller.dart';
import 'package:gossip_go/features/auth/screens/widgets/user_profile_image_widget.dart';
import 'package:gossip_go/utils/colors.dart';

class UserInformationScreen extends ConsumerWidget {
  const UserInformationScreen({super.key});
  static const pageName = '/user-information';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void onAddImageTap() =>
        ref.read(authControllerProvider.notifier).pickImage(context: context);
    void saveUserData() => ref
        .read(authControllerProvider.notifier)
        .saveUserInfoToFireStore(context: context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final height = constraints.maxHeight;
            final width = constraints.maxWidth;
            return Column(
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
                            child: SizedBox(
                              width: width * 0.6,
                              child: TextFormField(
                                controller: ref
                                    .read(authControllerProvider.notifier)
                                    .userNameController,
                                decoration: const InputDecoration(
                                    hintText: 'Enter username'),
                              ),
                            ),
                          )),
                      Expanded(
                          flex: 1,
                          child: Align(
                              alignment: Alignment.topCenter,
                              child: IconButton(
                                  onPressed: saveUserData,
                                  icon: const Icon(Icons.done))))
                    ],
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
