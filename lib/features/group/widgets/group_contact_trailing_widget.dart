import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gossip_go/features/group/controller/group_screen_notifier.dart';
import 'package:gossip_go/utils/colors.dart';

class GroupTileTrailing extends ConsumerWidget {
  const GroupTileTrailing({super.key, required this.contactIndex});
  final int contactIndex;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(groupScreenNotifierProvider);
    return ref
            .watch(groupScreenNotifierProvider.notifier)
            .selectedContactsIndex
            .contains(contactIndex)
        ? const Icon(
            Icons.done,
            color: tabColor,
          )
        : const SizedBox();
  }
}
