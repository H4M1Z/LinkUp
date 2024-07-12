import 'package:flutter/material.dart';

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({super.key});
  static const errorText = 'Page Not Found';
  static const pageName = '/errorPage';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Text(
          errorText,
          style: TextStyle(
              color: Colors.red,
              fontSize: MediaQuery.sizeOf(context).height * 0.05),
        ),
      ),
    );
  }
}
