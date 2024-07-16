import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gossip_go/features/chat/controller/chat_notifier.dart';

class AvatarIcon extends ConsumerWidget {
  const AvatarIcon(
      {super.key, required this.groupOrReceiverId, required this.isGroupChat});
  final String groupOrReceiverId;
  final bool isGroupChat;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(chatNotifierProvider);
    //when sending the message we will check if the message if single chat message or group chat message
    void sendTextMessage() async {
      if (ref.read(chatNotifierProvider.notifier).avatarIcon == Icons.send) {
        ref.read(chatNotifierProvider.notifier).sendTextMessage(
              context: context,
              groupOrReceiverId: groupOrReceiverId,
              isGroupChat: isGroupChat,
            );
      } else {
        ref.read(chatNotifierProvider.notifier).sendAudioMessage(
              context: context,
              groupOrReceiverId: groupOrReceiverId,
              isGroupChat: isGroupChat,
            );
      }
    }

    return GestureDetector(
      onTap: sendTextMessage,
      child: Icon(
        ref.read(chatNotifierProvider.notifier).avatarIcon,
        color: Colors.black,
      ),
    );
  }
}
