import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gossip_go/screens/camera_screen.dart/controller/camera_notifier.dart';
import 'package:gossip_go/screens/camera_screen.dart/widgets/list_tile_trailing.dart';
import 'package:gossip_go/utils/colors.dart';

class SendPictureScreen extends ConsumerWidget {
  const SendPictureScreen({super.key});
  static const pageName = '/send-picture-screen';
  static const usersList = [
    'LPZjg3YaayPJicchecbw26HqxbY2',
    'x3fELe83UzNMgNdvdkOQf9LqATE3'
  ];
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var file = ModalRoute.of(context)!.settings.arguments as File;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Send To'),
        elevation: 0.0,
        scrolledUnderElevation: 0.0,
        backgroundColor: backgroundColor,
      ),
      body: Center(
        child: ListView.builder(
          itemCount: usersList.length,
          itemBuilder: (context, index) {
            return ListTile(
              onTap: () => ref
                  .read(cameraNotifierProvider.notifier)
                  .onTileTap(index, usersList[index]),
              title: Text(usersList[index]),
              trailing: ListTileTrailingWidget(index),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => ref.read(cameraNotifierProvider.notifier).sendPicture(
              context: context,
              file: file,
            ),
        backgroundColor: tabColor,
        child: const Icon(
          Icons.send_rounded,
          color: Colors.black,
        ),
      ),
    );
  }
}
