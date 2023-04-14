import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:x_chat/API/apis.dart';
import 'package:x_chat/helper/dialogs.dart';
import 'package:x_chat/models/chat_user.dart';

import '../../login/login_screen.dart';

class ProfileController extends GetxController {
  final formkey = GlobalKey<FormState>();

  RxString? images;

  void galleryPicker(ChatUser image) async {
    ImagePicker picker = ImagePicker();
    final XFile? image =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (image != null) {
      print('Image Path: ${image.path} -- MimeType : ${image.mimeType}');

      final images = image.path;

      APIs.updateProfilePicture(File(images));
    }
    Get.back();
  }

  cameraPicker(ChatUser image) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image =
        await picker.pickImage(source: ImageSource.camera, imageQuality: 80);
    if (image != null) {
      print('Image Path: ${image.path}');

      final images = image.path;

      APIs.updateProfilePicture(File(images));
    }
    Get.back();
  }

  void floatingBtnPress() async {
    Dialogs.showProgressBar();
    await APIs.updateActiveStatus(false);

    await APIs.auth.signOut().then((value) async {
      await GoogleSignIn().signOut().then((value) {
        Get.back();

        APIs.auth = FirebaseAuth.instance;
        Get.to(() => LoginScreen());
      });
    });
  }

  void updateBtn() async {
    if (formkey.currentState!.validate()) {
      formkey.currentState!.save();
      APIs.updateUserInfo().then((value) {
        Dialogs.showSnackbar('Profile Updated SuccessFully !');
      });
      print('inside validator');
    }
  }
}
