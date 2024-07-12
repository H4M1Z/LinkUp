import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gossip_go/features/auth/screens/error_screen/error_screen.dart';
import 'package:gossip_go/features/auth/screens/loading_screen/loading_screen.dart';
import 'package:gossip_go/features/select_contacts/controller/select_contacts_notifier.dart';
import 'package:gossip_go/utils/colors.dart';
import 'package:gossip_go/utils/strings.dart';

class SelectContactsScreen extends ConsumerWidget {
  const SelectContactsScreen({super.key});
  static const pageName = '/select-contacts';
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Size(:height) = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        scrolledUnderElevation: 0.0,
        backgroundColor: backgroundColor,
        title: const Text(selectContactsScreenAppBarTitle),
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.search,
                color: Colors.white,
              )),
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.more_vert,
                color: Colors.white,
              ))
        ],
      ),
      body: ref.watch(getContactsProvider).when(
            data: (contacts) {
              return ListView.builder(
                itemCount: contacts.length,
                itemBuilder: (context, index) {
                  final contact = contacts[index];
                  return InkWell(
                    onTap: () => ref
                        .read(selectContactNotifierProvider.notifier)
                        .checkUser(context: context, selectedContact: contact),
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
                      ),
                    ),
                  );
                },
              );
            },
            error: (error, stackTrace) => const ErrorScreen(),
            loading: () => const LoadingScreen(),
          ),
    );
  }
}
