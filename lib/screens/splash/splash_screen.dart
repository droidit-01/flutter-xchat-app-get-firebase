import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:x_chat/screens/splash/controller/splashController.dart';
import '../../main.dart';

class SpashScreen extends StatelessWidget {
  const SpashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return GetBuilder<SplashController>(
      init: SplashController(),
      global: false,
      builder: (controller) => Scaffold(
        body: Stack(
          children: [
            Positioned(
              top: mq.height * .10,
              right: mq.width * .20,
              width: mq.width * .6,
              height: mq.height * .6,
              child: Image.asset('assets/logo.png'),
            ),
            Positioned(
              bottom: mq.height * .15,
              width: mq.width,
              child: const Text(
                'MADE IN INDIA WITH Odan💙',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                  letterSpacing: .5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
