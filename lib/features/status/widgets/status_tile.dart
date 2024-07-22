import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gossip_go/models/status_model.dart';
import 'package:intl/intl.dart';

class StatusTile extends ConsumerWidget {
  const StatusTile({
    super.key,
    required this.status,
    required this.onTap,
    required this.titleStyle,
    required this.subtitleStyle,
  });
  final VoidCallback onTap;
  final StatusModel status;
  final TextStyle titleStyle, subtitleStyle;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Size(:height) = MediaQuery.sizeOf(context);
    return ListTile(
      onTap: onTap,
      leading: CircleAvatar(
        radius: height * 0.045,
        backgroundImage: NetworkImage(
          status.profilePic,
        ),
      ),
      title: Text(
        status.userName,
        style: titleStyle,
      ),
      subtitle: Text(
        DateFormat("h:mma").format(status.createdTime),
        style: subtitleStyle,
      ),
    );
  }
}
