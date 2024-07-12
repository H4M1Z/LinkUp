import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gossip_go/features/status/view/status_contacts_screen.dart';
import 'package:gossip_go/screens/contacts_screen/controller/mobile_layout_screen_notifier.dart';
import 'package:gossip_go/screens/contacts_screen/view/contacts_page.dart';

class PageViewHandler extends ConsumerWidget {
  const PageViewHandler({super.key, required this.pageViewController});
  final PageController pageViewController;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PageView(
      onPageChanged: (value) => ref
          .read(mobileLayoutScreenProvider.notifier)
          .onBottomBarTap(index: value, pageController: pageViewController),
      controller: pageViewController,
      children: [
        const ContactsPage(),
        const StatusScreen(),
        Container(
          color: Colors.amber,
        )
      ],
    );
  }
}