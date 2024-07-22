import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gossip_go/screens/mobile_layout_screen/controller/mobile_layout_screen_notifier.dart';

class FloatingButtonIcon extends ConsumerWidget {
  const FloatingButtonIcon({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(mobileLayoutScreenProvider);
    return Icon(
      ref.read(mobileLayoutScreenProvider.notifier).fabIcon,
      color: Colors.black,
    );
  }
}
