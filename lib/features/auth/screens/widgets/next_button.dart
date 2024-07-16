import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gossip_go/features/auth/controller/auth_controller.dart';
import 'package:gossip_go/utils/colors.dart';

class LoginScreenButton extends ConsumerWidget {
  const LoginScreenButton(this.camera, {super.key});
  final CameraDescription camera;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void sendPhoneNumber() {
      ref
          .read(authControllerProvider.notifier)
          .signInWithPhoneNumber(context: context, camera: camera);
    }

    const btntText = 'Next';
    return LayoutBuilder(
      builder: (context, constraints) => GestureDetector(
        onTap: () => sendPhoneNumber(),
        child: Container(
          width: constraints.maxWidth * 0.3,
          height: constraints.maxHeight * 0.5,
          decoration: BoxDecoration(
              color: tabColor, borderRadius: BorderRadius.circular(40)),
          child: const Center(
            child: Text(
              btntText,
              style: TextStyle(color: Colors.black),
            ),
          ),
        ),
      ),
    );
  }
}
