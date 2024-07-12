// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:gossip_go/utils/messages_enum.dart';

class MessageReply {
  final String message;
  final bool isMe;
  final MessageEnum messageType;
  MessageReply({
    required this.message,
    required this.isMe,
    required this.messageType,
  });
}
