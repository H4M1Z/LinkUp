import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gossip_go/features/call/controller/call_notifier.dart';
import 'package:gossip_go/features/call/screens/call_pickup_screen.dart';
import 'package:gossip_go/features/chat/widgets/chat_text_field.dart';
import 'package:gossip_go/features/chat/widgets/chats_list.dart';
import 'package:gossip_go/features/chat/widgets/user_name_status_widget.dart';
import 'package:gossip_go/features/select_contacts/repository/select_contact_repo.dart';
import 'package:gossip_go/utils/colors.dart';

class MobileChatScreen extends ConsumerWidget {
  const MobileChatScreen({super.key});
  static const pfpRadius = 17.0;
  static const pageName = '/chat-screen';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Size(
      :width,
    ) = MediaQuery.sizeOf(context);
    final info =
        ModalRoute.of(context)!.settings.arguments as ChatScreenArguments;
    return CallPickUpScreen(
      scaffold: Scaffold(
        appBar: AppBar(
          backgroundColor: backgroundColor,
          elevation: 0.0,
          scrolledUnderElevation: 0.0,
          leadingWidth: width * 0.55,
          leading: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                flex: 4,
                child: IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.arrow_back_sharp)),
              ),
              Expanded(
                flex: 10,
                child: CircleAvatar(
                  radius: pfpRadius,
                  backgroundImage: CachedNetworkImageProvider(info.profilePic),
                ),
              ),
              Expanded(
                flex: 20,
                child: UserNameAndStatus(
                  groupOrReceiverId: info.groupOrReceiverId,
                  name: info.name,
                  isGroupChat: info.isgroupChat,
                ),
              ),
            ],
          ),
          centerTitle: false,
          actions: [
            IconButton(
              onPressed: () => ref.read(callNotifierProvider.notifier).makeCall(
                    context: context,
                    callReceievrPic: info.profilePic,
                    callReceiverName: info.name,
                    callReceiverUid: info.groupOrReceiverId,
                    isGroupChat: info.isgroupChat,
                  ),
              icon: const Icon(Icons.videocam_outlined),
            ),
          ],
        ),
        body: Column(
          // emoji wala ka thora issue hay aur textField kay click pr ar emoji on hay ussay close kr dena hay
          children: [
            Expanded(
              child: ChatList(
                groupOrReceiverId: info.groupOrReceiverId,
                isGroupChat: info.isgroupChat,
              ),
            ),
            ChatTextField(
              groupOrReceiverId: info.groupOrReceiverId,
              isGroupChat: info.isgroupChat,
              receiverName: info.name,
            ),
          ],
        ),
      ),
    );
  }
}
