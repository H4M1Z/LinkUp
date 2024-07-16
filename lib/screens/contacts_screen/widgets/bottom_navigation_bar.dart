import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gossip_go/screens/contacts_screen/controller/mobile_layout_screen_notifier.dart';
import 'package:gossip_go/utils/colors.dart';
import 'package:gossip_go/utils/strings.dart';

class MobileLayoutScreenBottomBar extends ConsumerStatefulWidget {
  const MobileLayoutScreenBottomBar(
      {super.key, required this.pageViewController});
  final PageController pageViewController;

  @override
  ConsumerState<MobileLayoutScreenBottomBar> createState() =>
      _MobileLayoutScreenBottomBarState();
}

class _MobileLayoutScreenBottomBarState
    extends ConsumerState<MobileLayoutScreenBottomBar> {
  static const iconSize = 20.0;
  static const elevation = 20.0;
  @override
  Widget build(BuildContext context) {
    ref.watch(mobileLayoutScreenProvider);
    return BottomNavigationBar(
        elevation: elevation,
        selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.bold, color: Colors.white, fontSize: 12),
        iconSize: iconSize,
        onTap: (value) {
          ref.read(mobileLayoutScreenProvider.notifier).onBottomBarTap(
              index: value, pageController: widget.pageViewController);
        },
        currentIndex:
            ref.read(mobileLayoutScreenProvider.notifier).bottomBarCurrentIndex,
        backgroundColor: backgroundColor,
        items: const [
          BottomNavigationBarItem(
              label: bottomBarChats,
              icon: Icon(Icons.chat_outlined, color: Colors.white),
              activeIcon: Icon(
                Icons.chat_rounded,
                color: bottomBarSelectedIconColor,
              )),
          BottomNavigationBarItem(
              label: bottomBarStories,
              icon: Icon(Icons.auto_stories_outlined, color: Colors.white),
              activeIcon: Icon(
                Icons.auto_stories_sharp,
                color: bottomBarSelectedIconColor,
              )),
        ]);
  }
}
