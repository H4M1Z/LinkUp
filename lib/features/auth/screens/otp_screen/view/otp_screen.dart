import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gossip_go/features/auth/controller/auth_controller.dart';
import 'package:gossip_go/features/auth/controller/auth_states.dart';
import 'package:gossip_go/features/auth/screens/widgets/otp_screen_textfield.dart';
import 'package:gossip_go/utils/strings.dart';

class OTPScreen extends ConsumerWidget {
  const OTPScreen({super.key});
  static const pageName = '/otp-screen';
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var verificationId = ModalRoute.of(context)!.settings.arguments as String;
    const description = 'Enter the code we sent you through SMS.';
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text(
          otpScreenAppBarTitle,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            children: [
              const Expanded(
                  flex: 1,
                  child: Center(
                    child: Text(description),
                  )),
              Expanded(
                  flex: 9,
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: OTPTextField(
                      verificationId: verificationId,
                    ),
                  ))
            ],
          ),
          Builder(
            builder: (context) {
              var state = ref.watch(authControllerProvider);
              if (state is AuthLoadingState) {
                return const CircularProgressIndicator();
              } else {
                return const SizedBox();
              }
            },
          )
        ],
      ),
    );
  }
}
