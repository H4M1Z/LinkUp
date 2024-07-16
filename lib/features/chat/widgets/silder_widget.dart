import 'dart:developer';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gossip_go/features/chat/controller/chat_notifier.dart';

class AudioSliderWidget extends ConsumerWidget {
  const AudioSliderWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(chatNotifierProvider);
    return Slider(
        allowedInteraction: SliderInteraction.tapAndSlide,
        activeColor: Colors.green.shade300,
        thumbColor: Colors.grey,
        min: 0,
        max: ref
            .read(chatNotifierProvider.notifier)
            .duration
            .inSeconds
            .toDouble(),
        value: ref
            .read(chatNotifierProvider.notifier)
            .audioPosition
            .inSeconds
            .toDouble(),
        onChanged: ref.read(chatNotifierProvider.notifier).onSliderChange);
  }
}

class AudioSlider extends StatefulWidget {
  const AudioSlider({super.key, required this.message});
  final String message;
  @override
  State<AudioSlider> createState() => _AudioSliderState();
}

class _AudioSliderState extends State<AudioSlider> {
  final player = AudioPlayer();
  bool isPlaying = false;
  var duration = Duration.zero;
  var position = Duration.zero;

  @override
  void initState() {
    super.initState();
    player.onPlayerStateChanged.listen(
      (event) {
        isPlaying = event == PlayerState.playing;
        setState(() {});
      },
    );

    player.onDurationChanged.listen(
      (event) {
        setState(() {
          duration = event;
        });
      },
    );
    player.onPositionChanged.listen(
      (event) {
        setState(() {
          position = event;
        });
      },
    );

    player.onPlayerComplete.listen(
      (event) {
        setState(() {
          isPlaying = false;
          duration = Duration.zero;
          position = Duration.zero;
          player.stop();
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: () {
            if (isPlaying) {
              player.pause();
            } else {
              log('message in widget : ${widget.message}');
              player.play(UrlSource(widget.message));
            }
          },
          child: Icon(
            isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
            color: Colors.grey,
            size: 40,
          ),
        ),
        Slider(
          allowedInteraction: SliderInteraction.tapAndSlide,
          activeColor: Colors.green.shade300,
          thumbColor: Colors.grey,
          min: 0,
          max: duration.inSeconds.toDouble(),
          value: position.inSeconds.toDouble(),
          onChanged: (value) {
            final position = Duration(seconds: value.toInt());
            player.seek(position);
            player.resume();
          },
        )
      ],
    );
  }
}
