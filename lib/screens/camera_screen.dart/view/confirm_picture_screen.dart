import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gossip_go/screens/camera_screen.dart/view/send_picture_screen.dart';
import 'package:gossip_go/utils/colors.dart';

class ConfirmPicutureScreen extends ConsumerWidget {
  const ConfirmPicutureScreen({super.key});
  static const pageName = '/confirm-picture-screen';
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final file = ModalRoute.of(context)!.settings.arguments as File;

    void addStatus() {
      Navigator.popAndPushNamed(context, SendPictureScreen.pageName,
          arguments: file);
    }

    return Scaffold(
      body: Center(
        child: AspectRatio(
          aspectRatio: 9 / 16,
          child: Image.file(
            file,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addStatus,
        backgroundColor: tabColor,
        focusColor: tabColor,
        splashColor: tabColor,
        hoverColor: tabColor,
        child: const Icon(
          Icons.done,
          color: Colors.black,
        ),
      ),
    );
  }
}
