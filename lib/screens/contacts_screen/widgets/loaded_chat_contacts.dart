import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gossip_go/models/chat_contact_model.dart';
import 'package:gossip_go/screens/contacts_screen/widgets/contact_group_chat_list_tile.dart';
import 'package:intl/intl.dart';

class LoadedChatContacts extends ConsumerWidget {
  const LoadedChatContacts(
      {super.key, required this.itemCount, required this.chatContacts});
  final int itemCount;
  final List<ChatContactModel> chatContacts;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SliverList.builder(
      itemCount: itemCount,
      itemBuilder: (context, index) {
        var chatContact = chatContacts[index];
        return ContactAndGroupChatListTile(
          index: index,
          groupOrReceiverId: chatContact.contactId,
          username: chatContact.name,
          lastMessage: chatContact.lastMessage,
          profilepic: chatContact.profilePic,
          time: DateFormat("h:mma").format(chatContact.time),
          isGroupChat: false,
        );
      },
    );
  }
}
