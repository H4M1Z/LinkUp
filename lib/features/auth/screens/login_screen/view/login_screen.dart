import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gossip_go/features/auth/controller/auth_controller.dart';
import 'package:gossip_go/features/auth/controller/auth_states.dart';
import 'package:gossip_go/features/auth/screens/widgets/country_code_text.dart';
import 'package:gossip_go/features/auth/screens/widgets/login_scren_text_field.dart';
import 'package:gossip_go/features/auth/screens/widgets/next_button.dart';
import 'package:gossip_go/utils/colors.dart';
import 'package:gossip_go/utils/strings.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});
  static const pageName = '/loginPage';
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const verifyText = 'Gossip Go will need to verify your phone number.';
    const btnText = 'Pick Country';
    final Size(:width, :height) = MediaQuery.sizeOf(context);
    var camera =
        ModalRoute.of(context)!.settings.arguments as CameraDescription;
    return Scaffold(
        backgroundColor: backgroundColor,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: backgroundColor,
          title: const FittedBox(
            child: Text(
              loginAppBarTitle,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          centerTitle: true,
        ),
        body: Stack(
          children: [
            Column(children: [
              const Expanded(
                flex: 1,
                child: Center(
                  child: Text(verifyText),
                ),
              ),
              Expanded(
                flex: 1,
                child: Center(
                  child: TextButton(
                      onPressed: () {
                        ref
                            .read(authControllerProvider.notifier)
                            .onPickCountryTap(context);
                      },
                      child: const Text(
                        btnText,
                        style: TextStyle(
                          color: Colors.blue,
                        ),
                      )),
                ),
              ),
              Expanded(
                flex: 8,
                child: Row(
                  children: [
                    Expanded(
                        flex: 1,
                        child: Align(
                            alignment: Alignment.topRight,
                            child: Padding(
                              padding: EdgeInsets.only(
                                  top: height * 0.03, right: width * 0.02),
                              child: const CountryCodeText(),
                            ))),
                    const Expanded(
                        flex: 4,
                        child: Align(
                            alignment: Alignment.topLeft,
                            child: LoginPageTextField())),
                  ],
                ),
              ),
              Expanded(flex: 2, child: Center(child: LoginScreenButton(camera)))
            ]),
            Builder(
              builder: (context) {
                var state = ref.watch(authControllerProvider);
                if (state is AuthLoadingState) {
                  return const CircularProgressIndicator(
                    color: tabColor,
                  );
                } else {
                  return const SizedBox();
                }
              },
            )
          ],
        ));
  }
}
