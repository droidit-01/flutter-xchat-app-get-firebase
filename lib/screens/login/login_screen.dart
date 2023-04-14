import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:x_chat/screens/login/controller/loginController.dart';
import '../../main.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Welcome to XChat',
          style: GoogleFonts.poppins(
              color: const Color(0xff147efb),
              fontSize: 23,
              fontWeight: FontWeight.w500),
        ),
      ),
      body: GetBuilder<LoginController>(
        init: LoginController(),
        global: false,
        builder: (controller) {
          return Stack(
            fit: StackFit.expand,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.only(bottom: 250),
                    child: Image.asset(
                      'assets/logo.png',
                      width: controller.animation!.value * 250,
                      height: controller.animation!.value * 250,
                    ),
                  ),
                ],
              ),
              Positioned(
                bottom: mq.height * .15,
                left: mq.width * .05,
                width: mq.width * .9,
                height: mq.height * .07,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    elevation: 5,
                    backgroundColor: const Color(0xff147efb),
                    shape: const StadiumBorder(),
                  ),
                  onPressed: () {
                    controller.handleGoogleBtnClick();
                  },
                  icon: Image.asset(
                    'assets/g.png',
                    height: mq.height * .05,
                  ),
                  label: Text(
                    'Signin with Google',
                    style: GoogleFonts.poppins(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
