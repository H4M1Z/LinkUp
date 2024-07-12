import 'package:flutter/material.dart';
import 'package:gossip_go/utils/colors.dart';

class AgreeContinueButton extends StatelessWidget {
  const AgreeContinueButton({super.key, required this.onTap});
  final VoidCallback onTap;
  static const btnText = 'AGREE AND CONTINUE';

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final height = constraints.maxHeight;
        return GestureDetector(
          onTap: onTap,
          child: Container(
            width: width * 0.8,
            height: height * 0.5,
            decoration: BoxDecoration(
                color: tabColor, borderRadius: BorderRadius.circular(40)),
            child: const Center(
              child: Text(
                btnText,
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        );
      },
    );
  }
}
