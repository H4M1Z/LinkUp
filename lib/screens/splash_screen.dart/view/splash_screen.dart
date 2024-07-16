import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  //controller
  late final AnimationController controller;
//animations
  late final Animation<double> scaleAnimation;
  late final Animation<double> fadeAnimation;
//tweens
  final tweenForScale = Tween<double>(begin: 0.8, end: 1.0);
  final tweenForFade = Tween<double>(begin: 0.6, end: 1.0);

  @override
  void initState() {
    super.initState();
    // controller initialization
    controller = AnimationController(
      vsync: this,
      duration: const Duration(
        seconds: 3,
      ),
    )
      ..addStatusListener(
        (status) {
          if (status == AnimationStatus.completed) {
            controller.reverse();
          } else if (status == AnimationStatus.dismissed) {
            controller.forward();
          }
        },
      )
      ..forward();
    // animation initialization
    scaleAnimation = tweenForScale.animate(controller);
    fadeAnimation = tweenForFade.animate(controller);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const appName = 'LinkUp';
    final Size(:height) = MediaQuery.sizeOf(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: ScaleTransition(
          scale: scaleAnimation,
          child: FadeTransition(
            opacity: fadeAnimation,
            child: Text(
              appName,
              style: TextStyle(
                  color: Colors.cyan,
                  fontWeight: FontWeight.w600,
                  fontSize: height * 0.06),
            ),
          ),
        ),
      ),
    );
  }
}
