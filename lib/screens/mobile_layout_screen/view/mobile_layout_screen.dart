import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gossip_go/features/auth/controller/auth_controller.dart';
import 'package:gossip_go/features/call/screens/call_pickup_screen.dart';
import 'package:gossip_go/screens/mobile_layout_screen/controller/mobile_layout_screen_notifier.dart';
import 'package:gossip_go/screens/mobile_layout_screen/widgets/bottom_navigation_bar.dart';
import 'package:gossip_go/screens/mobile_layout_screen/widgets/fab_icon.dart';
import 'package:gossip_go/screens/mobile_layout_screen/widgets/pageview_selector.dart';
import 'package:gossip_go/utils/colors.dart';

class MobileLayoutScreen extends ConsumerStatefulWidget {
  const MobileLayoutScreen({super.key, required this.camera});
  static const pageName = '/mobile-layout-screen';
  final CameraDescription camera;
  @override
  ConsumerState<MobileLayoutScreen> createState() => _MobileLayoutScreenState();
}

class _MobileLayoutScreenState extends ConsumerState<MobileLayoutScreen>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    SchedulerBinding.instance.addPostFrameCallback(
      (timeStamp) {
        ref.read(authControllerProvider.notifier).setUserStatus(isOnline: true);
      },
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    //in this function we will determine wether user is online or offline adn we manage this in the auth repo
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.detached:
      case AppLifecycleState.resumed:
        ref.read(authControllerProvider.notifier).setUserStatus(
              isOnline: true,
            );
        break;
      case AppLifecycleState.hidden:
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
        ref.read(authControllerProvider.notifier).setUserStatus(
              isOnline: false,
            );
        break;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size(:height) = MediaQuery.sizeOf(context);
    final pageViewController = PageController(initialPage: 0);
    return CallPickUpScreen(
      scaffold: Scaffold(
        body: PageViewHandler(
            pageViewController: pageViewController, camera: widget.camera),
        floatingActionButton: FloatingActionButton(
          onPressed: () => ref
              .read(mobileLayoutScreenProvider.notifier)
              .onFloatingActionButtonTap(context: context),
          backgroundColor: tabColor,
          child: const FloatingButtonIcon(),
        ),
        bottomNavigationBar: SizedBox(
          height: height * 0.13,
          child: MobileLayoutScreenBottomBar(
            pageViewController: pageViewController,
          ),
        ),
      ),
    );
  }
}
