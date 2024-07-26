import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gossip_go/features/status/controller/status_notifier.dart';
import 'package:gossip_go/features/status/widgets/user_status_tile.dart';
import 'package:gossip_go/screens/mobile_layout_screen/controller/mobile_layout_screen_notifier.dart';

class UserStatusWidget extends ConsumerWidget {
  const UserStatusWidget({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const myListTileTitle = 'My status';
    const myListTileSubtitle = 'Tap to add status update';
    final Size(:height) = MediaQuery.sizeOf(context);
    final nameStyle = TextStyle(
      color: Colors.grey.shade300,
      fontSize: height * 0.024,
      fontWeight: FontWeight.w500,
    );
    final statusController = ref.read(statusNotifierProvider.notifier);

    return FutureBuilder(
      future: ref.read(statusNotifierProvider.notifier).getUserStatus(context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return UserStatusTile(
            hasStatus: statusController.userHasStatus(),
            profilePic: statusController.userPfp ?? '',
            onProfilePicTap: () =>
                statusController.onUserProfilePicTap(context, snapshot.data),
            onTileTap: () => ref
                .read(mobileLayoutScreenProvider.notifier)
                .onAddStatusTap(context: context),
            title: myListTileTitle,
            titleStyle: nameStyle,
            subtitle: myListTileSubtitle,
            subtitleStyle: TextStyle(color: Colors.grey.shade400),
          );
        }

        return UserStatusTile(
          hasStatus: statusController.userHasStatus(),
          onTileTap: () => ref
              .read(mobileLayoutScreenProvider.notifier)
              .onAddStatusTap(context: context),
          titleStyle: nameStyle,
          subtitleStyle: TextStyle(color: Colors.grey.shade400),
          profilePic: statusController.userPfp ?? '',
          title: myListTileTitle,
          subtitle: myListTileSubtitle,
          onProfilePicTap: () => statusController.onUserProfilePicTap(context),
        );
      },
    );
  }
}
