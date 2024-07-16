import 'package:cached_video_player/cached_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gossip_go/features/chat/controller/chat_notifier.dart';
import 'package:gossip_go/features/chat/widgets/video_player_icon_widget.dart';

class VideoPlayerWidget extends ConsumerStatefulWidget {
  const VideoPlayerWidget({super.key, required this.videoUrl});
  final String videoUrl;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends ConsumerState<VideoPlayerWidget> {
  late final CachedVideoPlayerController videoController;
  @override
  void initState() {
    super.initState();
    videoController = CachedVideoPlayerController.network(widget.videoUrl)
      ..initialize().then(
        // the highest volume
        (value) => videoController.setVolume(1),
      );
  }

  @override
  void dispose() {
    videoController.dispose();
    super.dispose();
  }

  void _onBtnTap() {
    ref.read(chatNotifierProvider.notifier).onPlayVideoTap(videoController);
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 18,
      child: Stack(
        children: [
          CachedVideoPlayer(
            videoController,
          ),
          Center(
            child: IconButton(onPressed: _onBtnTap, icon: const VideoIcon()),
          )
        ],
      ),
    );
  }
}
