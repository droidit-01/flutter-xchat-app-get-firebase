import 'dart:async';

import 'package:get/get.dart';
import 'package:x_chat/API/apis.dart';
import 'package:x_chat/screens/login/login_screen.dart';

class SplashController extends GetxController {
  @override
  void onInit() async {
    startTime();
    super.onInit();
  }

  static startTime() async {
    var duration = const Duration(seconds: 2);
    return Timer(duration, navigationPage);
  }

  static navigationPage() async {
    if (APIs.auth.currentUser != null) {
      print('\nUser : ${APIs.auth.currentUser}');
      Get.to(() => const LoginScreen());
    } else {
      Get.to(() => const LoginScreen());
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
