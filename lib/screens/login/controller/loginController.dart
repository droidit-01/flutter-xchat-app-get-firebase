import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:x_chat/API/apis.dart';
import 'package:x_chat/helper/dialogs.dart';
import 'package:x_chat/screens/home/home_screen.dart';

class LoginController extends GetxController
    with GetSingleTickerProviderStateMixin {
  AnimationController? animationController;
  Animation<double>? animation;

  @override
  void onInit() {
    animationInitilization();
    super.onInit();
  }

  animationInitilization() {
    animationController =
        AnimationController(duration: const Duration(seconds: 2), vsync: this);
    animation =
        CurvedAnimation(parent: animationController!, curve: Curves.easeOut)
            .obs
            .value;
    animation!.addListener(() => update());
    animationController!.forward();
  }

  handleGoogleBtnClick() {
    Dialogs.showProgressBar();

    signInWithGoogle().then((user) async {
      Get.back();
      if (user != null) {
        print('\nUser:${user.user}');
        print('\nUserAdditionInfo: ${user.additionalUserInfo}');
        // log('\nUser: ${user.user}' as num);
        // log('\nUserAdditionInfo: ${user.additionalUserInfo}' as num);

        if ((await APIs.userExists())) {
          Get.to(() => const HomeScreen());
        } else {
          await APIs.createUser().then((value) {
            Get.to(() => const HomeScreen());
          });
        }
      }
    });
  }

  Future<UserCredential?> signInWithGoogle() async {
    try {
      await InternetAddress.lookup('google.com');
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      return await APIs.auth.signInWithCredential(credential);
    } catch (e) {
      print(e);
      Dialogs.showSnackbar('Something went wrong (Check Internet!)');
      return null;
    }
  }
}
