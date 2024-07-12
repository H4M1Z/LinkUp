import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gossip_go/features/auth/screens/error_screen/error_screen.dart';
import 'package:gossip_go/features/group/controller/group_screen_notifier.dart';
import 'package:gossip_go/features/group/widgets/group_contact_trailing_widget.dart';
import 'package:gossip_go/features/select_contacts/controller/select_contacts_notifier.dart';
import 'package:gossip_go/utils/colors.dart';

class GroupContacts extends ConsumerWidget {
  const GroupContacts({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Size(:height) = MediaQuery.sizeOf(context);
    return ref.watch(getContactsProvider).when(
          data: (contacts) {
            return ListView.builder(
              itemCount: contacts.length,
              itemBuilder: (context, index) {
                final contact = contacts[index];
                return InkWell(
                  onTap: () => ref
                      .read(groupScreenNotifierProvider.notifier)
                      .onContactTap(contact: contact, contactIndex: index),
                  child: Padding(
                    padding: EdgeInsets.only(bottom: height * 0.015),
                    child: ListTile(
                      leading: contact.photo == null
                          ? null
                          : CircleAvatar(
                              backgroundImage: MemoryImage(contact.photo!),
                            ),
                      title: Text(
                        contact.displayName,
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
          },
          error: (error, stackTrace) => const ErrorScreen(),
          loading: () => const Center(
            child: CircularProgressIndicator(
              color: tabColor,
            ),
          ),
        );
  }
}
