import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:x_chat/screens/splash/splash_screen.dart';

late Size mq;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((value) {
    _initializeFirebase();

    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'x chat ',
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          centerTitle: true,
          elevation: 1,
          iconTheme: const IconThemeData(
            color: Colors.black,
          ),
          titleTextStyle: GoogleFonts.poppins(
            color: Colors.black,
            fontWeight: FontWeight.normal,
            fontSize: 19,
          ),
        ),
      ),
      home: const SpashScreen(),
    );
  }
}

_initializeFirebase() async {
  await Firebase.initializeApp();

  // var result = await FlutterNotificationChannel.registerNotificationChannel(
  //   description: 'For Showing Message Notification',
  //   id: 'chats',
  //   importance: NotificationImportance.IMPORTANCE_HIGH,
  //   name: 'Chats',
  // );
  // print('\nNotification Channel Result : $result');
}
// C:\src\projects\x_chat\android\app\  keytool -genkey -v -keystore %userprofile%\upload-keystore.jks -storetype JKS -keyalg RSA -keysize 2048 -validity 10000 -alias upload
// c:/src/xchatkey.jks