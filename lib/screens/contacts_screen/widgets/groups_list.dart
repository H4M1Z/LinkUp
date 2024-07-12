import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gossip_go/features/chat/controller/chat_notifier.dart';
import 'package:gossip_go/models/group_model.dart';
import 'package:gossip_go/screens/contacts_screen/widgets/loaded_group_chats.dart';

class GroupsList extends ConsumerWidget {
  const GroupsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var chatController = ref.read(chatNotifierProvider.notifier);
    return StreamBuilder<List<GroupModel>>(
      stream: ref.watch(chatNotifierProvider.notifier).getGroupChats(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return LoadedGroupChats(
              itemCount: chatController.groupChats.length,
              groups: chatController.groupChats);
        }
        chatController.groupChats = snapshot.data ?? [];
        return LoadedGroupChats(
            itemCount: snapshot.data!.length, groups: snapshot.data!);
      },
    );
  }
}
