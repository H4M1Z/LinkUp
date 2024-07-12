import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gossip_go/features/group/controller/group_screen_notifier.dart';
import 'package:gossip_go/utils/colors.dart';

class GroupScreenTextField extends ConsumerWidget {
  const GroupScreenTextField({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const hintText = 'Enter Group Name';
    const border = UnderlineInputBorder(
      borderSide: BorderSide(
        color: tabColor,
      ),
    );
    final Size(:width) = MediaQuery.sizeOf(context);
    return SizedBox(
      width: width * 0.95,
      child: TextFormField(
        cursorColor: tabColor,
        controller:
            ref.read(groupScreenNotifierProvider.notifier).groupNameController,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(left: width * 0.03),
          border: border,
          enabledBorder: border,
          focusedBorder: border,
          hintText: hintText,
          hintStyle: TextStyle(
            color: Colors.grey.shade300,
            fontWeight: FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
