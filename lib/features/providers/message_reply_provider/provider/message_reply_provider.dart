import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gossip_go/features/providers/message_reply_provider/model/message_reply_model.dart';
import 'package:gossip_go/features/providers/message_reply_provider/provider/message_reply_states.dart';

final messageReplyProvider =
    NotifierProvider<MessageReplyNotifier, MessageReplyStates>(
        MessageReplyNotifier.new);

class MessageReplyNotifier extends Notifier<MessageReplyStates> {
  @override
  MessageReplyStates build() {
    return MessageReplyInitialState();
  }

  void onMessageSwipe({
    required MessageReply messageReply,
  }) {
    state = MessageReplyLoadingState();
    state = MessageReplyLoadedState(messageReply: messageReply);
  }

  void changeState() {
    state = MessageReplyInitialState();
  }
}
