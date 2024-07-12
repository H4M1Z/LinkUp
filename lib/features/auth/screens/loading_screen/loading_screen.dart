import 'package:flutter/material.dart';
import 'package:gossip_go/utils/colors.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});
  static const pageName = '/loadingPage';
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(
        color: tabColor,
      ),
    );
  }
}
