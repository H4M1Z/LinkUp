// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:gossip_go/utils/messages_enum.dart';

class MessageModel {
  final String senderId;
  // we need receiverid to see if the message is seen by the reciver or not
  final String receiverId;
  final String message;
  final MessageEnum messageType;
  final DateTime timeSent;
  final String messageId;
  final bool isSeen;
  final String replyText;
  final String repliedTo;
  final MessageEnum repliedMessageType;
  MessageModel({
    required this.senderId,
    required this.receiverId,
    required this.message,
    required this.messageType,
    required this.timeSent,
    required this.messageId,
    required this.isSeen,
    required this.replyText,
    required this.repliedTo,
    required this.repliedMessageType,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'senderId': senderId,
      'receiverId': receiverId,
      'message': message,
      'messageType': messageType.type,
      'timeSent': timeSent.millisecondsSinceEpoch,
      'messageId': messageId,
      'isSeen': isSeen,
      'replyText': replyText,
      'repliedTo': repliedTo,
      'repliedMessageType': repliedMessageType.type,
    };
  }

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      senderId: map['senderId'] as String,
      receiverId: map['receiverId'] as String,
      message: map['message'] as String,
      messageType: (map['messageType'] as String).toEnum(),
      timeSent: DateTime.fromMillisecondsSinceEpoch(map['timeSent'] as int),
      messageId: map['messageId'] as String,
      isSeen: map['isSeen'] as bool,
      replyText: map['replyText'] as String,
      repliedTo: map['repliedTo'] as String,
      repliedMessageType: (map['repliedMessageType'] as String).toEnum(),
    );
  }
}
