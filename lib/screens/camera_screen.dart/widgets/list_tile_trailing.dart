import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gossip_go/screens/camera_screen.dart/controller/camera_notifier.dart';
import 'package:gossip_go/utils/colors.dart';

class ListTileTrailingWidget extends ConsumerWidget {
  const ListTileTrailingWidget(this.index, {super.key});
  final int index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(cameraNotifierProvider);
    return ref
            .read(cameraNotifierProvider.notifier)
            .selectedUsersIndex
            .contains(index)
        ? const Icon(
            Icons.done,
            color: tabColor,
          )
        : const SizedBox();
  }
}
