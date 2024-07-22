import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gossip_go/features/auth/controller/auth_controller.dart';

class CountryCodeText extends ConsumerWidget {
  const CountryCodeText({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Size(:height) = MediaQuery.sizeOf(context);
    ref.watch(authControllerProvider);
    return Text(
      ref.read(authControllerProvider.notifier).countryCode,
      style: TextStyle(
          fontSize: height * 0.028, decoration: TextDecoration.underline),
    );
  }
}
