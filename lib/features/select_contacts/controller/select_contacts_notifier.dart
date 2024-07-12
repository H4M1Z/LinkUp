import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gossip_go/features/select_contacts/controller/select_contacts_states.dart';
import 'package:gossip_go/features/select_contacts/repository/select_contact_repo.dart';

final getContactsProvider = FutureProvider(
  (ref) {
    final selectContactRepository = ref.watch(selectRpositoryProvider);
    return selectContactRepository.getContacts();
  },
);

final selectContactNotifierProvider =
    NotifierProvider<SelectContactsNotifier, SelectContactsScreenStates>(
        SelectContactsNotifier.new);

class SelectContactsNotifier extends Notifier<SelectContactsScreenStates> {
  @override
  SelectContactsScreenStates build() {
    ref.read(selectRpositoryProvider);
    return SelectContactsInitialState();
  }

  checkUser({required Contact selectedContact, required BuildContext context}) {
    ref
        .read(selectRpositoryProvider)
        .checkUser(selectedContact: selectedContact, context: context);
  }
}
