import 'package:flutter/material.dart';
import 'package:gossip_go/features/providers/message_reply_provider/model/message_reply_model.dart';

@immutable
abstract class MessageReplyStates {
  const MessageReplyStates();
}

@immutable
final class MessageReplyInitialState extends MessageReplyStates {}

@immutable
final class MessageReplyLoadingState extends MessageReplyStates {}

@immutable
final class MessageReplyLoadedState extends MessageReplyStates {
  final MessageReply messageReply;
  const MessageReplyLoadedState({required this.messageReply});
}
