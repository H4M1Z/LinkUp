import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gossip_go/features/group/controller/group_screen_notifier.dart';
import 'package:gossip_go/features/group/widgets/group_contact_trailing_widget.dart';
import 'package:gossip_go/models/user_model.dart';

class GroupContacts extends ConsumerWidget {
  const GroupContacts({super.key, required this.appUsers});
  final List<UserModel> appUsers;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Size(:height) = MediaQuery.sizeOf(context);
    return ListView.builder(
      itemCount: appUsers.length,
      itemBuilder: (context, index) {
        final contact = appUsers[index];
        return InkWell(
          onTap: () => ref
              .read(groupScreenNotifierProvider.notifier)
              .onContactTap(contact: contact, contactIndex: index),
          child: Padding(
            padding: EdgeInsets.only(bottom: height * 0.015),
            child: ListTile(
              title: Text(
                contact.name,
                style: TextStyle(fontSize: height * 0.025),
              ),
              trailing: GroupTileTrailing(
                contactIndex: index,
              ),
            ),
          ),
        );
      },
    );
  }
}
