import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gossip_go/features/group/controller/group_screen_states.dart';
import 'package:gossip_go/features/group/repository/group_repository.dart';
import 'package:gossip_go/models/user_model.dart';
import 'package:gossip_go/utils/common_functions.dart';

final groupScreenNotifierProvider =
    NotifierProvider<GroupScreenNotifier, GroupScreenState>(
        GroupScreenNotifier.new);

class GroupScreenNotifier extends Notifier<GroupScreenState> {
  final TextEditingController groupNameController = TextEditingController();
  File? groupImage;
  List<int> selectedContactsIndex = [];
  List<UserModel> selectedContacts = [];

  @override
  GroupScreenState build() {
    ref.onDispose(
      () => groupNameController.dispose(),
    );
    return GroupScreenInitialState();
  }

  void pickGroupImage(BuildContext context) async {
    state = GroupScreenLoadingState();
    groupImage = await pickImageFromGallery(context: context);
    state = GroupScreenLoadedState();
  }

  void onContactTap({required int contactIndex, required UserModel contact}) {
    state = GroupScreenLoadingState();
    if (selectedContactsIndex.contains(contactIndex)) {
      selectedContactsIndex.remove(contactIndex);
      selectedContacts.removeWhere((element) => element.name == contact.name);

      log(selectedContacts.length.toString());
    } else {
      selectedContactsIndex.add(contactIndex);
      selectedContacts.add(contact);
    }

    state = GroupScreenLoadedState();
  }

  void createGroup(BuildContext context) {
    if (groupNameController.text.trim().isNotEmpty && groupImage != null) {
      ref.read(groupRepositoryProvider).createGroup(
            context: context,
            groupName: groupNameController.text.trim(),
            groupImage: groupImage!,
            selectedContacts: selectedContacts,
          );
      selectedContacts = [];
      Navigator.pop(context);
    }
  }
}
