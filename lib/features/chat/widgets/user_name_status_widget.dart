import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gossip_go/features/auth/controller/auth_controller.dart';
import 'package:gossip_go/features/chat/controller/chat_notifier.dart';
import 'package:gossip_go/models/user_model.dart';

class UserNameAndStatus extends ConsumerWidget {
  const UserNameAndStatus({
    super.key,
    required this.groupOrReceiverId,
    required this.name,
    required this.isGroupChat,
  });
  final String groupOrReceiverId, name;
  final bool isGroupChat;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Size(:height) = MediaQuery.sizeOf(context);
    return isGroupChat
        ? FutureBuilder(
            future: ref
                .watch(chatNotifierProvider.notifier)
                .groupDataById(groupId: groupOrReceiverId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Spacer(
                      flex: 2,
                    ),
                    Expanded(
                      flex: 10,
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: FittedBox(
                          child: Text(
                            name,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: height * 0.025,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 10,
                      child: RichText(
                          text: TextSpan(children: [
                        for (int i = 0;
                            i < snapshot.data!.groupMemberIds.length;
                            i++)
                          if (i == snapshot.data!.groupMemberIds.length - 1)
                            TextSpan(
                              text: snapshot.data!.groupMemberNames[i],
                              style: TextStyle(
                                fontSize: height * 0.018,
                              ),
                            )
                          else
                            TextSpan(
                              text: '${snapshot.data!.groupMemberNames[i]},',
                              style: TextStyle(
                                fontSize: height * 0.018,
                              ),
                            )
                      ])),
                    )
                  ],
                );
              }
              return const SizedBox();
            },
          )
        : StreamBuilder<UserModel>(
            stream: ref
                .read(authControllerProvider.notifier)
                .userDataById(userId: groupOrReceiverId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done ||
                  snapshot.connectionState == ConnectionState.active) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Spacer(
                      flex: 2,
                    ),
                    Expanded(
                        flex: 10,
                        child: Align(
                            alignment: Alignment.bottomLeft,
                            child: Text(name))),
                    Expanded(
                      flex: 10,
                      child: Text(
                        snapshot.data!.isOnline ? 'Online' : 'Offline',
                        style: TextStyle(
                            fontSize: height * 0.016,
                            fontWeight: FontWeight.normal),
                      ),
                    )
                  ],
                );
              }
              return const SizedBox();
            },
          );
  }
}
