import 'package:flutter/material.dart';
import 'package:gossip_go/features/chat/widgets/message_type_widget.dart';
import 'package:gossip_go/features/chat/widgets/my_message_card.dart';
import 'package:gossip_go/utils/colors.dart';
import 'package:gossip_go/utils/messages_enum.dart';
import 'package:swipe_to/swipe_to.dart';

class SenderMessageCard extends StatelessWidget {
  const SenderMessageCard({
    super.key,
    required this.message,
    required this.date,
    required this.messageType,
    required this.onRightSwipe,
    required this.repliedText,
    required this.receiverUserName,
    required this.repliedMessageType,
    required this.isGroupChat,
    required this.senderUserName,
  });
  final String message, date, repliedText, receiverUserName, senderUserName;
  final MessageEnum messageType;
  final SwipeCallBack onRightSwipe;
  final MessageEnum repliedMessageType;
  final bool isGroupChat;
  @override
  Widget build(BuildContext context) {
    final isReplying = repliedText.isNotEmpty;
    final Size(:width, :height) = MediaQuery.sizeOf(context);
    return SwipeTo(
      onRightSwipe: onRightSwipe,
      child: Align(
        alignment: Alignment.centerLeft,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width - 45,
          ),
          child: Card(
            elevation: 1,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            color: senderMessageColor,
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: Stack(
              children: [
                if (isReplying) ...[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(5),
                        child: Container(
                          height: height * 0.1,
                          decoration: BoxDecoration(
                            color: senderMessageReplyBoxColor,
                            borderRadius: BorderRadius.circular(
                              10,
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: width * 0.02,
                                decoration: const BoxDecoration(
                                  color: tabColor,
                                  borderRadius: BorderRadius.only(
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
                                  Padding(
                                    padding:
                                        EdgeInsets.only(left: width * 0.02),
                                    child: Text(
                                      receiverUserName,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: tabColor,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.only(left: width * 0.02),
                                    child: SizedBox(
                                      width: width * 0.7,
                                      height: height * 0.05,
                                      child: MessageType(
                                        isReply: true,
                                        message: repliedText,
                                        messageType: repliedMessageType,
                                      ),
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: messageType == MessageEnum.text
                            ? EdgeInsets.only(
                                left: width * 0.02,
                                right: width * 0.22,
                                bottom: height * 0.01)
                            : const EdgeInsets.only(
                                top: 5,
                                left: 5,
                                right: 5,
                                bottom: 5,
                              ),
                        child: MessageType(
                          isReply: false,
                          message: message,
                          messageType: messageType,
                        ),
                      ),
                    ],
                  ),
                ] else
                //if group chat diplay this widget
                if (isGroupChat) ...[
                  Positioned(
                    left: 10,
                    top: 5,
                    child: Text(
                      senderUserName,
                      style: TextStyle(
                        color: Colors.yellow.shade700,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: messageType == MessageEnum.text
                        ? EdgeInsets.only(
                            left: width * 0.06,
                            right: width * 0.22,
                            top: 25,
                            bottom: height * 0.01,
                          )
                        : const EdgeInsets.only(
                            top: 15, left: 5, right: 5, bottom: 5),
                    child: MessageType(
                      isReply: false,
                      message: message,
                      messageType: messageType,
                    ),
                  ),
                  Positioned(
                    right: 10,
                    bottom: 4,
                    child: Text(
                      date,
                      style: TextStyle(
                        fontSize: 13,
                        color: messageType == MessageEnum.text
                            ? Colors.grey[600]
                            : Colors.white,
                      ),
                    ),
                  ),
                ] else
                  Padding(
                    padding: messageType == MessageEnum.text
                        ? EdgeInsets.only(
                            left: width * 0.03,
                            right: width * 0.22,
                            top: 5,
                            bottom: height * 0.01,
                          )
                        : const EdgeInsets.all(5),
                    child: MessageType(
                      isReply: false,
                      message: message,
                      messageType: messageType,
                    ),
                  ),
                Positioned(
                  right: 10,
                  bottom: 4,
                  child: Text(
                    date,
                    style: TextStyle(
                      fontSize: 13,
                      color: messageType == MessageEnum.text
                          ? Colors.grey[600]
                          : Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
