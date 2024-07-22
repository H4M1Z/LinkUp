import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:gossip_go/features/auth/screens/landing_screen/widgets/accept_continue_button.dart';
import 'package:gossip_go/features/auth/screens/login_screen/view/login_screen.dart';
import 'package:gossip_go/utils/colors.dart';
import 'package:gossip_go/utils/strings.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key, required this.camera});
  static const pageName = '/';
  static const backGroundImage = 'assets/images/landing_page_image.png';
  final CameraDescription camera;
  void _onBtnTap(BuildContext context) {
    Navigator.of(context).pushNamed(
      LoginScreen.pageName,
      arguments: camera,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(child: LayoutBuilder(
        builder: (context, constraints) {
          var height = constraints.maxHeight;
          return Column(
            children: [
              const Spacer(flex: 1),
              Expanded(
                  flex: 2,
                  child: Center(
                    child: FittedBox(
                      child: Text(
                        landingPageHeading,
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: height * 0.04),
                      ),
                    ),
                  )),
              Expanded(
                  flex: 5,
                  child: Center(
                    child: Image.asset(
                      backGroundImage,
                      fit: BoxFit.fill,
                    ),
                  )),
              const Expanded(
                  flex: 2,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Text(
                      privacyPolicy,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey),
                    ),
                  )),
              Expanded(
                  flex: 2,
                  child: Center(child: AgreeContinueButton(
                    onTap: () {
                      _onBtnTap(context);
                    },
                  )))
            ],
          );
        },
      )),
    );
  }
}
