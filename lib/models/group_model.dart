// ignore_for_file: public_member_api_docs, sort_constructors_first
class GroupModel {
  final String lastMessageSenderId;
  final String groupName;
  final String groupId;
  final String lastMessage;
  final String groupPic;
  final List<String> groupMemberIds;
  final List<String> groupMemberNames;
  final DateTime timeSent;
  GroupModel({
    required this.lastMessageSenderId,
    required this.groupName,
    required this.groupId,
    required this.lastMessage,
    required this.groupPic,
    required this.groupMemberIds,
    required this.groupMemberNames,
    required this.timeSent,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'lastMessageSenderId': lastMessageSenderId,
      'groupName': groupName,
      'groupId': groupId,
      'lastMessage': lastMessage,
      'groupPic': groupPic,
      'groupMemberIds': groupMemberIds,
      'groupMemberNames': groupMemberNames,
      'timeSent': timeSent.millisecondsSinceEpoch,
    };
  }

  factory GroupModel.fromMap(Map<String, dynamic> map) {
    return GroupModel(
      lastMessageSenderId: map['lastMessageSenderId'] as String,
      groupName: map['groupName'] as String,
      groupId: map['groupId'] as String,
      lastMessage: map['lastMessage'] as String,
      groupPic: map['groupPic'] as String,
      groupMemberIds: List<String>.from((map['groupMemberIds'] as List)),
      groupMemberNames: List<String>.from((map['groupMemberNames'] as List)),
      timeSent: DateTime.fromMillisecondsSinceEpoch(map['timeSent'] as int),
    );
  }
}
