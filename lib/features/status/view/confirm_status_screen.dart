import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gossip_go/features/status/controller/status_notifier.dart';
import 'package:gossip_go/utils/colors.dart';

class ConfirmStatusScreen extends ConsumerWidget {
  const ConfirmStatusScreen({super.key});
  static const pageName = '/confirm-status-screen';
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final file = ModalRoute.of(context)!.settings.arguments as File;

    void addStatus() {
      ref
          .read(statusNotifierProvider.notifier)
          .addStatus(context: context, statusImage: file);
      Navigator.pop(context);
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
      floatingActionButton: ElevatedButton(
        style: const ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(tabColor),
            shape: WidgetStatePropertyAll(CircleBorder())),
        onPressed: addStatus,
        child: const Icon(
          Icons.send,
          color: Colors.black,
        ),
      ),
    );
  }
}
