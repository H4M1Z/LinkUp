import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gossip_go/features/status/controller/status_notifier.dart';
import 'package:gossip_go/features/status/widgets/statuses_loaded_widget.dart';
import 'package:gossip_go/features/status/widgets/user_status_widget.dart';
import 'package:gossip_go/utils/colors.dart';
import 'package:gossip_go/utils/strings.dart';

class StatusScreen extends ConsumerWidget {
  const StatusScreen({super.key});
  static const pageName = '/status-screen';
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const statusHeading = 'Status';
    const recentHeading = 'Recent updates';
    final Size(:width, :height) = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: EdgeInsets.only(right: width * 0.1),
            child: const Icon(
              Icons.search,
              color: Colors.white,
            ),
          )
        ],
        title: const Text(
          statusScreenAppBarTitle,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        scrolledUnderElevation: 0.0,
        elevation: 0.0,
        backgroundColor: backgroundColor,
      ),
      body: Padding(
        padding: EdgeInsets.only(top: height * 0.03),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: width * 0.05),
              child: Text(
                statusHeading,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: height * 0.035,
                    fontWeight: FontWeight.w600),
              ),
            ),
            const UserStatusWidget(),
            Padding(
              padding: EdgeInsets.only(
                top: height * 0.02,
                left: width * 0.05,
                bottom: height * 0.01,
              ),
              child: Text(
                recentHeading,
                style: TextStyle(
                    color: Colors.grey.shade400,
                    fontSize: height * 0.023,
                    fontWeight: FontWeight.w500),
              ),
            ),
            Expanded(
              child: FutureBuilder(
                future: ref
                    .read(statusNotifierProvider.notifier)
                    .getStatuses(context),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return StatusesLoadedWidget(
                        itemCount: ref
                            .read(statusNotifierProvider.notifier)
                            .chachedStatuses
                            .length,
                        statuses: ref
                            .read(statusNotifierProvider.notifier)
                            .chachedStatuses);
                  }
                  return StatusesLoadedWidget(
                    itemCount: snapshot.data!.length,
                    statuses: snapshot.data!,
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
