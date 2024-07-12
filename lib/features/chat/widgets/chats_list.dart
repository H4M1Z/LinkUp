import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gossip_go/features/chat/controller/chat_notifier.dart';
import 'package:gossip_go/features/chat/widgets/messages_list.dart';
import 'package:gossip_go/models/message_model.dart';

class ChatList extends ConsumerWidget {
  const ChatList(
      {super.key, required this.groupOrReceiverId, required this.isGroupChat});
  final String groupOrReceiverId;
  final bool isGroupChat;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return StreamBuilder<List<MessageModel>>(
        stream: isGroupChat
            ? ref
                .read(chatNotifierProvider.notifier)
                .getGroupMessages(groupId: groupOrReceiverId)
            : ref
                .watch(chatNotifierProvider.notifier)
                .getContactMessages(receiverId: groupOrReceiverId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            SchedulerBinding.instance.addPostFrameCallback(
              (_) =>
                  ref.read(chatNotifierProvider.notifier).scrollToMaxPosition(),
            );
            return MessagesList(
              receiverUserId: groupOrReceiverId,
              itemCount:
                  ref.read(chatNotifierProvider.notifier).messages.length,
              messages: ref.read(chatNotifierProvider.notifier).messages,
              isGroupChat: isGroupChat,
            );
          }
          ref.read(chatNotifierProvider.notifier).messages =
              snapshot.data ?? [];
          SchedulerBinding.instance.addPostFrameCallback(
            (_) =>
                ref.read(chatNotifierProvider.notifier).scrollToMaxPosition(),
          );
          return MessagesList(
            receiverUserId: groupOrReceiverId,
            itemCount: snapshot.data!.length,
            messages: snapshot.data!,
            isGroupChat: isGroupChat,
          );
        });
  }
}
