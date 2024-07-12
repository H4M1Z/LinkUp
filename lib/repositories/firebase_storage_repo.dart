import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final firebaseStorageRepositoryProvider =
    Provider<FireBaseStorageRepositiory>((ref) {
  return FireBaseStorageRepositiory(firebaseStorage: FirebaseStorage.instance);
});

class FireBaseStorageRepositiory {
  final FirebaseStorage firebaseStorage;
  const FireBaseStorageRepositiory({
    required this.firebaseStorage,
  });

  //this function will be responsible for saving all the files (audio,video,image) etc...
  Future<String> saveFileToStorage(
      {required String path, required File file}) async {
    /**
   * this is going to save the file to the path that we provide it as the path will be different so we take the path from the parameter
   * for example when we save userinfo we will save it in User/uid/info folder path 
   * when we want to store sender message we will store it in User/uid/userMessages and if we want to store recvied message we will store it in User/uid/senderMessages
   */
    UploadTask uploadTask = firebaseStorage.ref().child(path).putFile(file);
    //this will get us the download url from storage
    TaskSnapshot snapshot = await uploadTask;
    //now we will get the download url and return it
    return await snapshot.ref.getDownloadURL();
  }

  Future<String> getnoPfp() async {
    return await firebaseStorage
        .ref()
        .child('profilePic')
        .child('no_pfp.png')
        .getDownloadURL();
  }
}
