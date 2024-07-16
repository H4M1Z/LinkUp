// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gossip_go/features/select_contacts/view/select_contacts_screen.dart';
import 'package:gossip_go/features/status/view/confirm_status_screen.dart';
import 'package:gossip_go/screens/contacts_screen/controller/mobile_layout_states.dart';
import 'package:gossip_go/utils/common_functions.dart';

final mobileLayoutScreenProvider =
    NotifierProvider<MobileLayoutScreenNotifier, ContactsScreenStates>(
        MobileLayoutScreenNotifier.new);

class MobileLayoutScreenNotifier extends Notifier<ContactsScreenStates> {
  @override
  ContactsScreenStates build() {
    return ContactScreenInitialState();
  }

  var bottomBarCurrentIndex = 0;
  var fabIcon = Icons.add_comment;

  void onBottomBarTap(
      {required int index, required PageController pageController}) {
    state = ContactScreenLoadingState();
    pageController.jumpToPage(index);
    bottomBarCurrentIndex = index;
    fabIcon = switch (index) {
      0 => Icons.add_comment,
      _ => Icons.camera_alt,
    };
    state = ContactScreenLoadedState();
  }

  onAddContatcsTap(BuildContext context) =>
      Navigator.of(context).pushNamed(SelectContactsScreen.pageName);

  onAddStatusTap({
    required BuildContext context,
  }) async {
    File? file = await pickImageFromGallery(context: context);
    if (file != null) {
      Navigator.of(context).pushNamed(
        ConfirmStatusScreen.pageName,
        arguments: file,
      );
    }
  }

  onCallTap() => '';

  void onFloatingActionButtonTap({
    required BuildContext context,
  }) {
    switch (bottomBarCurrentIndex) {
      case 0:
        onAddContatcsTap(context);
        break;
      case 1:
        onAddStatusTap(context: context);
      default:
    }
  }
}
