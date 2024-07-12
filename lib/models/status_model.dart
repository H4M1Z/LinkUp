// ignore_for_file: public_member_api_docs, sort_constructors_first

class StatusModel {
  final String uid;
  final String userName;
  final String phoneNumber;
  //status images
  final List<String> photosUrl;
  final DateTime createdTime;
  final String profilePic;
  final String statusId;
  //other people who can see our status
  final List<String> visibleTo;
  StatusModel({
    required this.uid,
    required this.userName,
    required this.phoneNumber,
    required this.photosUrl,
    required this.createdTime,
    required this.profilePic,
    required this.statusId,
    required this.visibleTo,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'userName': userName,
      'phoneNumber': phoneNumber,
      'photosUrl': photosUrl,
      'createdTime': createdTime.millisecondsSinceEpoch,
      'profilePic': profilePic,
      'statusId': statusId,
      'visibleTo': visibleTo,
    };
  }

  factory StatusModel.fromMap(Map<String, dynamic> map) {
    return StatusModel(
      uid: map['uid'] as String,
      userName: map['userName'] as String,
      phoneNumber: map['phoneNumber'] as String,
      photosUrl: List<String>.from(
        (map['photosUrl'] as List),
      ),
      createdTime:
          DateTime.fromMillisecondsSinceEpoch(map['createdTime'] as int),
      profilePic: map['profilePic'] as String,
      statusId: map['statusId'] as String,
      visibleTo: List<String>.from(
        (map['visibleTo'] as List),
      ),
    );
  }
}
