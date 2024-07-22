import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gossip_go/features/chat/widgets/message_type_widget.dart';
import 'package:gossip_go/features/providers/message_reply_provider/provider/message_reply_provider.dart';
import 'package:gossip_go/utils/colors.dart';
import 'package:gossip_go/utils/messages_enum.dart';

class MessageReplyView extends ConsumerWidget {
  const MessageReplyView({
    super.key,
    required this.replyingText,
    required this.isMe,
    required this.messageReplyType,
    required this.receiverName,
  });
  final String replyingText, receiverName;
  final bool isMe;
  final MessageEnum messageReplyType;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Size(:width, :height) = MediaQuery.sizeOf(context);
    void onCancleBtnTap() =>
        ref.read(messageReplyProvider.notifier).changeState();
    return Padding(
      padding: EdgeInsets.only(left: width * 0.02),
      child: Container(
        width: width * 0.8,
        height: height * 0.13,
        padding: const EdgeInsets.all(8.0),
        decoration: const BoxDecoration(
          color: mobileChatBoxColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          ),
        ),
        child: Container(
          width: width * 0.5,
          decoration: BoxDecoration(
            color: replyBoxColor,
            borderRadius: BorderRadius.circular(
              10,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: width * 0.02,
                decoration: BoxDecoration(
                  color: isMe ? tabColor : Colors.purple,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(
                      10,
                    ),
                    bottomLeft: Radius.circular(
                      10,
                    ),
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: width * 0.68,
                        child: Padding(
                          padding: EdgeInsets.only(left: width * 0.02),
                          child: Text(
                            isMe ? 'You' : receiverName,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: isMe ? tabColor : Colors.purple,
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: onCancleBtnTap,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.clear,
                            size: height * 0.02,
                          ),
                        ),
                      )
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: width * 0.02),
                    child: SizedBox(
                        width: width * 0.7,
                        height: height * 0.07,
                        child: MessageType(
                          isReply: false,
                          message: replyingText,
                          messageType: messageReplyType,
                        )),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
