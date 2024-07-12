import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gossip_go/models/group_model.dart';
import 'package:gossip_go/screens/contacts_screen/widgets/contact_group_chat_list_tile.dart';
import 'package:intl/intl.dart';

class LoadedGroupChats extends ConsumerWidget {
  const LoadedGroupChats(
      {super.key, required this.itemCount, required this.groups});
  final int itemCount;
  final List<GroupModel> groups;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SliverList.builder(
      itemCount: itemCount,
      itemBuilder: (context, index) {
        var group = groups[index];
        return ContactAndGroupChatListTile(
          index: index,
          username: group.groupName,
          lastMessage: group.lastMessage,
          profilepic: group.groupPic,
          time: DateFormat("h:mma").format(group.timeSent),
          groupOrReceiverId: group.groupId,
          isGroupChat: true,
        );
      },
    );
  }
}
