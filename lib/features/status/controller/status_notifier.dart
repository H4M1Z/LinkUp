import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gossip_go/features/auth/controller/auth_controller.dart';
import 'package:gossip_go/features/status/controller/status_states.dart';
import 'package:gossip_go/features/status/repositories/status_repository.dart';
import 'package:gossip_go/features/status/view/show_status_screen.dart';
import 'package:gossip_go/models/status_model.dart';
import 'package:story_view/controller/story_controller.dart';
import 'package:story_view/utils.dart';
import 'package:story_view/widgets/story_view.dart';

final statusNotifierProvider = NotifierProvider<StatusNotifier, StatusStates>(
  StatusNotifier.new,
);

class StatusNotifier extends Notifier<StatusStates> {
  final StoryController storyController = StoryController();
  List<StoryItem> storyItems = [];
  var chachedStatuses = <StatusModel>[];
  StatusModel? chahcedUserStatuses;

  @override
  StatusStates build() {
    return StatusInitialState();
  }

  void addStatus({
    required BuildContext context,
    required File statusImage,
  }) {
    ref.read(userProvider).whenData(
          (user) => ref.read(statusRepositoryProvider).uploadStatus(
              context: context,
              username: user!.name,
              profilePicture: user.profilePic,
              phoneNumber: user.phoneNumber,
              statusImage: statusImage),
        );
  }

  Future<List<StatusModel>> getStatuses(BuildContext context) async {
    chachedStatuses =
        await ref.read(statusRepositoryProvider).getStatuses(context: context);
    return chachedStatuses;
  }

  Future<StatusModel?> getUserStatus(BuildContext context) async {
    chahcedUserStatuses =
        await ref.read(statusRepositoryProvider).getUserStatus();
    return chahcedUserStatuses;
  }

  bool userHasStatus() {
    return chahcedUserStatuses != null;
  }

  void onUserProfilePicTap(BuildContext context, [StatusModel? status]) {
    if (userHasStatus()) {
      onShowStatusTap(context: context, status: status ?? chahcedUserStatuses!);
    }
  }

  void onShowStatusTap(
      {required BuildContext context, required StatusModel status}) {
    Navigator.of(context)
        .pushNamed(ShowStatusScreen.pageName, arguments: status);
  }

  void addItemsToStoriesList(List<String> photosUrl) {
    for (var i = 0; i < photosUrl.length; i++) {
      storyItems.add(
        StoryItem.pageImage(
          url: photosUrl[i],
          controller: storyController,
        ),
      );
    }
  }

  void onDownDrag(
      {required BuildContext context, required Direction? direction}) {
    if (direction == Direction.down) {
      Navigator.pop(context);
    }
  }
}
