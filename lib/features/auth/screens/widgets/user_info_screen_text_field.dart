import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gossip_go/features/auth/controller/auth_controller.dart';
import 'package:gossip_go/utils/colors.dart';

class UserInfoScreenTextField extends ConsumerWidget {
  const UserInfoScreenTextField({
    super.key,
    required this.width,
  });
  final double width;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const border =
        UnderlineInputBorder(borderSide: BorderSide(color: tabColor));
    const hintText = 'Enter username';
    return SizedBox(
      width: width * 0.6,
      child: TextFormField(
        cursorColor: tabColor,
        controller:
            ref.read(authControllerProvider.notifier).userNameController,
        decoration: const InputDecoration(
          border: border,
          focusedBorder: border,
          enabledBorder: border,
          hintText: hintText,
        ),
      ),
    );
  }
}
