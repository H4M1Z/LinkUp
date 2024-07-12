import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gossip_go/features/auth/controller/auth_controller.dart';

class ProfileImageAvatar extends ConsumerWidget {
  const ProfileImageAvatar({super.key});
  static const noPfpImage = 'assets/images/no_pfp.png';
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Size(:height) = MediaQuery.sizeOf(context);
    ref.watch(authControllerProvider);
    return ref.read(authControllerProvider.notifier).image == null
        ? CircleAvatar(
            radius: height * 0.1,
            backgroundImage: const AssetImage(noPfpImage),
          )
        : CircleAvatar(
            radius: height * 0.1,
            backgroundImage:
                FileImage(ref.read(authControllerProvider.notifier).image!),
          );
  }
}
