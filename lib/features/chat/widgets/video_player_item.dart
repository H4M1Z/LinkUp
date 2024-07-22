import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWidget extends ConsumerStatefulWidget {
  const VideoPlayerWidget({super.key, required this.videoUrl});
  final String videoUrl;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends ConsumerState<VideoPlayerWidget> {
  late final VideoPlayerController videoController;
  late final ChewieController chewieContoller;
  @override
  void initState() {
    super.initState();
    videoController = VideoPlayerController.networkUrl(
      Uri.parse(
        widget.videoUrl,
      ),
    )..initialize().then(
        // the highest volume
        (value) => videoController.setVolume(1),
      );
    chewieContoller = ChewieController(
      videoPlayerController: videoController,
      allowFullScreen: true,
      allowMuting: true,
      aspectRatio: 16 / 18,
      materialProgressColors: ChewieProgressColors(
        backgroundColor: Colors.grey.shade200,
        handleColor: Colors.grey.shade400,
        playedColor: Colors.green,
      ),
    );
  }

  @override
  void dispose() {
    videoController.dispose();
    chewieContoller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 18,
      child: Stack(
        children: [
          Chewie(
            controller: chewieContoller,
          ),
        ],
      ),
    );
  }
}
