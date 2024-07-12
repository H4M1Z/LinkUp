import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gossip_go/features/group/controller/group_screen_notifier.dart';

class GroupImageAvatar extends ConsumerWidget {
  const GroupImageAvatar({super.key});
  static const noPfpImage = 'assets/images/no_pfp.png';
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Size(:height) = MediaQuery.sizeOf(context);
    ref.watch(groupScreenNotifierProvider);
    return ref.read(groupScreenNotifierProvider.notifier).groupImage == null
        ? CircleAvatar(
            radius: height * 0.1,
            backgroundImage: const AssetImage(noPfpImage),
          )
        : CircleAvatar(
            radius: height * 0.1,
            backgroundImage: FileImage(
                ref.read(groupScreenNotifierProvider.notifier).groupImage!),
          );
  }
}
