// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:enough_giphy_flutter/enough_giphy_flutter.dart';
import 'package:flutter/material.dart';
import 'package:gossip_go/utils/colors.dart';
import 'package:image_picker/image_picker.dart';

void showSnackBar({required BuildContext context, required String data}) =>
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 1),
        backgroundColor: backgroundColor,
        content: Text(
          data,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );

Future<File?> pickImageFromGallery({required BuildContext context}) async {
  File? image;
  try {
    var pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      image = File(pickedImage.path);
    }
  } catch (e) {
    showSnackBar(context: context, data: e.toString());
  }

  return image;
}

Future<File?> pickVideoFromGallery({required BuildContext context}) async {
  File? vid;
  try {
    var pickedVid = await ImagePicker().pickVideo(source: ImageSource.gallery);
    if (pickedVid != null) {
      vid = File(pickedVid.path);
    }
  } catch (e) {
    showSnackBar(context: context, data: e.toString());
  }

  return vid;
}

Future<GiphyGif?> pickGif({required BuildContext context}) async {
  const apiKey = 'TrhiofgoNm7hestIOjQG3xsGNJDGVTKX';
  GiphyGif? gif;
  try {
    gif = await Giphy.getGif(
      context: context,
      apiKey: apiKey,
    );
  } catch (e) {
    showSnackBar(context: context, data: e.toString());
  }
  return gif;
}

String getPhoneNumber({required String number}) {
  String phoneNumber = '';
  if (number.startsWith('0')) {
    phoneNumber = number.replaceFirst(RegExp('0'), '+92');
    phoneNumber = phoneNumber.replaceAll(' ', '');
    return phoneNumber;
  } else {
    phoneNumber = number.replaceAll(' ', '');
    return phoneNumber;
  }
}
