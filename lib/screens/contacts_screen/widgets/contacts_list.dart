import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gossip_go/features/chat/controller/chat_notifier.dart';
import 'package:gossip_go/models/chat_contact_model.dart';
import 'package:gossip_go/screens/contacts_screen/widgets/loaded_chat_contacts.dart';

class ContactsList extends ConsumerWidget {
  const ContactsList({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return StreamBuilder<List<ChatContactModel>>(
        stream:
            ref.watch(chatNotifierProvider.notifier).getContactsLatestChat(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return LoadedChatContacts(
              itemCount:
                  ref.read(chatNotifierProvider.notifier).chatContacts.length,
              chatContacts:
                  ref.read(chatNotifierProvider.notifier).chatContacts,
            );
          }
          ref.read(chatNotifierProvider.notifier).chatContacts = snapshot.data!;
          return LoadedChatContacts(
            itemCount: snapshot.data!.length,
            chatContacts: snapshot.data!,
          );
        });
  }
}
