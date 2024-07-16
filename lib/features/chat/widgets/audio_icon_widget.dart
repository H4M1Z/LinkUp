import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gossip_go/features/chat/controller/chat_notifier.dart';

class AudioIcon extends ConsumerWidget {
  const AudioIcon({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Size(:height) = MediaQuery.sizeOf(context);
    ref.watch(chatNotifierProvider);
    return Icon(
      ref.read(chatNotifierProvider.notifier).audioIcon,
      color: Colors.grey,
      size: height * 0.05,
    );
  }
}
