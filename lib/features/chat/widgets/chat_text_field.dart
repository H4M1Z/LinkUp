import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gossip_go/features/chat/controller/chat_notifier.dart';
import 'package:gossip_go/features/chat/widgets/avatar_icon.dart';
import 'package:gossip_go/features/chat/widgets/emoji_icon_widget.dart';
import 'package:gossip_go/features/chat/widgets/message_reply_view.dart';
import 'package:gossip_go/features/providers/message_reply_provider/provider/message_reply_provider.dart';
import 'package:gossip_go/features/providers/message_reply_provider/provider/message_reply_states.dart';
import 'package:gossip_go/utils/colors.dart';
import 'package:gossip_go/utils/messages_enum.dart';

class ChatTextField extends ConsumerWidget {
  const ChatTextField({
    super.key,
    required this.groupOrReceiverId,
    required this.isGroupChat,
    required this.receiverName,
  });
  final String groupOrReceiverId, receiverName;
  final bool isGroupChat;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // members
    const fieldHintText = 'Message';
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: const BorderSide(
        width: 0,
        style: BorderStyle.none,
      ),
    );
    final Size(:width, :height) = MediaQuery.sizeOf(context);

    //functions
    void selectImage() =>
        ref.read(chatNotifierProvider.notifier).sendFileMessage(
              context: context,
              groupOrReceiverId: groupOrReceiverId,
              messageType: MessageEnum.image,
              isGroupChat: isGroupChat,
            );

    void selectVideo() =>
        ref.read(chatNotifierProvider.notifier).sendFileMessage(
              context: context,
              groupOrReceiverId: groupOrReceiverId,
              messageType: MessageEnum.video,
              isGroupChat: isGroupChat,
            );

    // ab humain message reply chahiye tha tu us nay state provider say kiya ay mein nay alag say states wghaira ban kr kiya ay my message card bhi update ki hay aur saray fucntions mein message reply required hay is liye sari changings hoi hain laikin ab is ko test krna hay... us nay
    void selectGif() => ref.read(chatNotifierProvider.notifier).sendGifMessage(
          context: context,
          groupOrReceiverId: groupOrReceiverId,
          isGroupChat: isGroupChat,
        );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Builder(
          builder: (context) {
            var state = ref.watch(messageReplyProvider);
            if (state is MessageReplyLoadedState) {
              return MessageReplyView(
                messageReplyType: state.messageReply.messageType,
                isMe: state.messageReply.isMe,
                replyingText: state.messageReply.message,
                receiverName: state.messageReply.messageSenderName,
              );
            } else {
              return const SizedBox();
            }
          },
        ),
        Row(
          children: [
            Expanded(
              flex: 5,
              child: TextField(
                focusNode:
                    ref.read(chatNotifierProvider.notifier).textFieldFocusNode,
                controller: ref
                    .read(chatNotifierProvider.notifier)
                    .messageTextController,
                onChanged: ref
                    .read(chatNotifierProvider.notifier)
                    .onTextFieldValueChanged,
                cursorColor: tabColor,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: mobileChatBoxColor,
                  prefixIcon: Padding(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.04),
                    child: SizedBox(
                      width: width * 0.27,
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: ref
                                .read(chatNotifierProvider.notifier)
                                .onEmojiIconTap,
                            icon: const EmojiIconWidget(),
                          ),
                          IconButton(
                            onPressed: selectGif,
                            icon: Icon(
                              Icons.gif_box_outlined,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  suffixIcon: SizedBox(
                    width: width * 0.3,
                    height: height * 0.08,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          onPressed: selectVideo,
                          icon: Icon(
                            Icons.attach_file_outlined,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        IconButton(
                          onPressed: selectImage,
                          icon: Icon(
                            Icons.camera_alt_outlined,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  hintText: fieldHintText,
                  hintStyle: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.normal,
                      fontSize: height * 0.027),
                  border: border,
                  contentPadding: const EdgeInsets.all(10),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Align(
                alignment: Alignment.center,
                child: CircleAvatar(
                  radius: height * 0.036,
                  backgroundColor: tabColor,
                  child: AvatarIcon(
                    groupOrReceiverId: groupOrReceiverId,
                    isGroupChat: isGroupChat,
                  ),
                ),
              ),
            )
          ],
        ),
        Builder(
          builder: (context) {
            ref.watch(chatNotifierProvider);
            if (ref.read(chatNotifierProvider.notifier).shouldDisplayEmojis) {
              return SizedBox(
                height: 202,
                child: EmojiPicker(
                  onEmojiSelected:
                      ref.read(chatNotifierProvider.notifier).onEmojiSelected,
                ),
              );
            } else {
              return const SizedBox();
            }
          },
        )
      ],
    );
  }
}
