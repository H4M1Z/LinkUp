import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gossip_go/features/chat/view/mobile_chat_screen.dart';
import 'package:gossip_go/features/select_contacts/repository/select_contact_repo.dart';

class ContactAndGroupChatListTile extends StatelessWidget {
  const ContactAndGroupChatListTile(
      {super.key,
      required this.index,
      required this.username,
      required this.lastMessage,
      required this.profilepic,
      required this.time,
      required this.groupOrReceiverId,
      required this.isGroupChat});
  final int index;
  final String username, lastMessage, profilepic, time, groupOrReceiverId;
  final bool isGroupChat;
  static const tilePaddingFromTop = 8.0;
  static const pfpRadius = 25.0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: tilePaddingFromTop),
      child: ListTile(
        onTap: () {
          Navigator.of(context).pushNamed(
            MobileChatScreen.pageName,
            //we have to pass a member which will tell wether this is a single chat or groupchat so taht we can fetch info relevent to that from the correct collection and the in the reciever id parameter we will snd the group id
            arguments: ChatScreenArguments(
              name: username,
              groupOrReceiverId: groupOrReceiverId,
              profilePic: profilepic,
              isgroupChat: isGroupChat,
            ),
          );
        },
        title: Text(
          username,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          lastMessage,
          style: const TextStyle(fontSize: 14, color: Colors.grey),
        ),
        leading: CircleAvatar(
          backgroundImage: CachedNetworkImageProvider(profilepic),
          radius: pfpRadius,
        ),
        trailing: Padding(
          padding: const EdgeInsets.only(bottom: 22.0),
          child: Text(
            time,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }
}
