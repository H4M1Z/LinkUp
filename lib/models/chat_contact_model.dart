// ignore_for_file: public_member_api_docs, sort_constructors_first
class ChatContactModel {
  final String name;
  final String profilePic;
  final DateTime time;
  final String contactId;
  final String lastMessage;
  ChatContactModel({
    required this.name,
    required this.profilePic,
    required this.time,
    required this.contactId,
    required this.lastMessage,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'profilePic': profilePic,
      'time': time.millisecondsSinceEpoch,
      'contactId': contactId,
      'lastMessage': lastMessage,
    };
  }

  factory ChatContactModel.fromMap(Map<String, dynamic> map) {
    return ChatContactModel(
      name: map['name'] as String,
      profilePic: map['profilePic'] as String,
      time: DateTime.fromMillisecondsSinceEpoch(map['time'] as int),
      contactId: map['contactId'] as String,
      lastMessage: map['lastMessage'] as String,
    );
  }

  @override
  String toString() {
    return 'ChatContactModel(name: $name, profilePic: $profilePic, time: $time, contactId: $contactId, lastMessage: $lastMessage)';
  }
}
