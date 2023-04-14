import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Dialogs {
  static void showSnackbar(String msg) {
    Get.snackbar(
      'Xchat',
      msg.toString(),
      backgroundColor: const Color(0xff147efb),
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
    );

    // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    //   content: Text(msg),
    //   backgroundColor: Colors.blue.withOpacity(.8),
    //   behavior: SnackBarBehavior.floating,
    // ));
  }

  static void showProgressBar() {
    Get.dialog(
      const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
