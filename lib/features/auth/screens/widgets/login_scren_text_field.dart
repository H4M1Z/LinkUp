import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gossip_go/features/auth/controller/auth_controller.dart';
import 'package:gossip_go/utils/colors.dart';
import 'package:gossip_go/utils/validtations.dart';

class LoginPageTextField extends ConsumerWidget {
  const LoginPageTextField({super.key});
  static const hintText = 'phone number';
  static const _fielderrorMessage = 'Only digits!';
  String? _numberValidator(String? value) {
    if (value.isAValidNumber()) {
      return null;
    } else {
      return _fielderrorMessage;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const border = UnderlineInputBorder(
      borderSide: BorderSide(color: tabColor),
    );
    return LayoutBuilder(
      builder: (context, constraints) => SizedBox(
        width: constraints.maxWidth * 0.8,
        child: TextFormField(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: _numberValidator,
          controller:
              ref.read(authControllerProvider.notifier).loginFieldController,
          cursorColor: tabColor,
          style: TextStyle(
              fontSize: constraints.maxHeight * 0.05,
              decoration: TextDecoration.none),
          decoration: InputDecoration(
              border: border,
              enabledBorder: border,
              focusedBorder: border,
              contentPadding:
                  EdgeInsets.only(top: constraints.maxHeight * 0.055),
              hintText: hintText,
              hintStyle: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: constraints.maxHeight * 0.035)),
        ),
      ),
    );
  }
}
