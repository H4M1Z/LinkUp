import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gossip_go/features/status/controller/status_notifier.dart';
import 'package:gossip_go/features/status/widgets/status_tile.dart';
import 'package:gossip_go/models/status_model.dart';

class StatusesLoadedWidget extends ConsumerWidget {
  const StatusesLoadedWidget({
    super.key,
    required this.itemCount,
    required this.statuses,
  });
  final int itemCount;
  final List<StatusModel> statuses;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Size(:height) = MediaQuery.sizeOf(context);
    final nameStyle = TextStyle(
      color: Colors.grey.shade300,
      fontSize: height * 0.024,
      fontWeight: FontWeight.w500,
    );
    final timeStyle = TextStyle(
      color: Colors.grey.shade400,
      fontSize: height * 0.023,
    );
    return Center(
      child: ListView.builder(
        itemCount: itemCount,
        itemBuilder: (context, index) {
          var status = statuses[index];
          return Padding(
              padding: EdgeInsets.only(top: height * 0.01),
              child: StatusTile(
                onTap: () =>
                    ref.read(statusNotifierProvider.notifier).onShowStatusTap(
                          context: context,
                          status: status,
                        ),
                status: status,
                titleStyle: nameStyle,
                subtitleStyle: timeStyle,
              ));
        },
      ),
    );
  }
}
