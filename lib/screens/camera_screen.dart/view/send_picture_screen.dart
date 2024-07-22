import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gossip_go/screens/camera_screen.dart/controller/camera_notifier.dart';
import 'package:gossip_go/screens/camera_screen.dart/widgets/list_tile_trailing.dart';
import 'package:gossip_go/utils/colors.dart';

class SendPictureScreen extends ConsumerWidget {
  const SendPictureScreen({super.key});
  static const pageName = '/send-picture-screen';
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var arguments = ModalRoute.of(context)?.settings.arguments as List;
    var file = arguments[0];
    var appusers = arguments[1];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Send To'),
        elevation: 0.0,
        scrolledUnderElevation: 0.0,
        backgroundColor: backgroundColor,
      ),
      body: Center(
        child: ListView.builder(
          itemCount: appusers.length,
          itemBuilder: (context, index) {
            return ListTile(
              onTap: () => ref
                  .read(cameraNotifierProvider.notifier)
                  .onTileTap(index, appusers[index].uid),
              title: Text(appusers[index].name),
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
