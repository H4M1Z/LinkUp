// ignore_for_file: public_member_api_docs, sort_constructors_first
class UserModel {
  final String name;
  final String uid;
  final String phoneNumber;
  final String profilePic;
  final bool isOnline;
  final List<String> groupIds;
  UserModel({
    required this.name,
    required this.uid,
    required this.phoneNumber,
    required this.profilePic,
    required this.isOnline,
    required this.groupIds,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'uid': uid,
      'phoneNumber': phoneNumber,
      'profilePic': profilePic,
      'isOnline': isOnline,
      'groupIds': groupIds,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
        name: map['name'] ?? '',
        uid: map['uid'] ?? '',
        phoneNumber: map['phoneNumber'] ?? '',
        profilePic: map['profilePic'] ?? '',
        isOnline: map['isOnline'] ?? false,
        groupIds: List<String>.from(
          (map['groupIds'] ?? ['']),
        ));
  }

  @override
  String toString() {
    return 'UserModel(name: $name, uid: $uid, phoneNumber: $phoneNumber, profilePic: $profilePic, isOnline: $isOnline, groupIds: $groupIds)';
  }
}
