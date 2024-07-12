import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gossip_go/features/auth/controller/auth_controller.dart';

class OTPTextField extends ConsumerWidget {
  const OTPTextField({super.key, required this.verificationId});
  final String verificationId;
  static const border =
      UnderlineInputBorder(borderSide: BorderSide(color: Colors.blue));
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const hintText = '- - - - - -';
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final height = constraints.maxHeight;
        return SizedBox(
          width: width * 0.5,
          child: TextFormField(
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
                border: border,
                enabledBorder: border,
                focusedBorder: border,
                hintText: hintText,
                hintStyle: TextStyle(fontSize: height * 0.065)),
            onChanged: (value) {
              if (value.length == 6) {
                ref.read(authControllerProvider.notifier).verifyOtp(
                    context: context,
                    verificationId: verificationId,
                    userOtp: value.trim());
              }
            },
          ),
        );
      },
    );
  }
}