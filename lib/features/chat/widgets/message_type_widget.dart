import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gossip_go/features/chat/controller/chat_notifier.dart';
import 'package:gossip_go/features/chat/widgets/audio_icon_widget.dart';
import 'package:gossip_go/features/chat/widgets/video_player_item.dart';
import 'package:gossip_go/utils/messages_enum.dart';

class MessageType extends ConsumerWidget {
  const MessageType(
      {super.key,
      required this.message,
      required this.messageType,
      required this.isReply});
  final String message;
  final MessageEnum messageType;
  final bool isReply;
  @override
  Widget build(BuildContext context, WidgetRef ref) => switch (messageType) {
        MessageEnum.text => Text(
            maxLines: isReply ? 2 : null,
            message,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
        MessageEnum.image || MessageEnum.gif => CachedNetworkImage(
            fit: BoxFit.fill,
            imageUrl: message,
          ),
        MessageEnum.video => VideoPlayerWidget(
            videoUrl: message,
          ),
        _ => IconButton(
            constraints: const BoxConstraints(minWidth: 100, minHeight: 60),
            onPressed: () {
              ref
                  .read(chatNotifierProvider.notifier)
                  .onAudioIconTap(audioSource: message);
            },
            icon: const AudioIcon(),
          ),
      };
}
