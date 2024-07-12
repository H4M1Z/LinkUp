import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gossip_go/features/status/controller/status_notifier.dart';
import 'package:gossip_go/models/status_model.dart';
import 'package:gossip_go/utils/colors.dart';
import 'package:story_view/story_view.dart';

class ShowStatusScreen extends ConsumerStatefulWidget {
  final StatusModel status;
  const ShowStatusScreen({super.key, required this.status});
  static const pageName = '/show-status-screen';
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ShowStatusScreenState();
}

class _ShowStatusScreenState extends ConsumerState<ShowStatusScreen> {
  final StoryController controller = StoryController();
  List<StoryItem> storyItems = [];
  @override
  void initState() {
    super.initState();
    addItemsToStoriesList();
  }

  addItemsToStoriesList() {
    for (var i = 0; i < widget.status.photosUrl.length; i++) {
      storyItems.add(
        StoryItem.pageImage(
          url: widget.status.photosUrl[i],
          controller: controller,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: storyItems.isEmpty
          ? const Center(
              child: CupertinoActivityIndicator(
                color: tabColor,
              ),
            )
          : StoryView(
              storyItems: storyItems,
              controller: controller,
              onVerticalSwipeComplete: (direction) => ref
                  .read(statusNotifierProvider.notifier)
                  .onDownDrag(context: context, direction: direction),
              onComplete: () => Navigator.pop(context),
            ),
    );
  }
}
