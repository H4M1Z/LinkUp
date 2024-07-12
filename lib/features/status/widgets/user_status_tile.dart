import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gossip_go/utils/colors.dart';

class UserStatusTile extends ConsumerWidget {
  const UserStatusTile(
      {super.key,
      required this.onTileTap,
      required this.titleStyle,
      required this.subtitleStyle,
      required this.profilePic,
      required this.title,
      required this.subtitle,
      required this.onProfilePicTap,
      required this.hasStatus});
  final VoidCallback onTileTap, onProfilePicTap;
  final String profilePic, title, subtitle;
  final TextStyle titleStyle, subtitleStyle;
  final bool hasStatus;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Size(:width, :height) = MediaQuery.sizeOf(context);
    return ListTile(
      onTap: onTileTap,
      leading: GestureDetector(
        onTap: onProfilePicTap,
        child: DecoratedBox(
          position: hasStatus
              ? DecorationPosition.foreground
              : DecorationPosition.background,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.transparent,
              border: Border.all(color: tabColor, width: width * 0.005)),
          child: CircleAvatar(
            radius: height * 0.045,
            backgroundImage: NetworkImage(
              profilePic,
            ),
          ),
        ),
      ),
      title: Text(
        title,
        style: titleStyle,
      ),
      subtitle: Text(
        subtitle,
        style: subtitleStyle,
      ),
    );
  }
}
