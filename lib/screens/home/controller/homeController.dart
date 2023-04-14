import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:x_chat/API/apis.dart';
import 'package:x_chat/models/chat_user.dart';
import '../../../helper/dialogs.dart';

class HomeController extends GetxController {
  List<ChatUser> list = [];

  // RxList<ChatUser> list = <ChatUser>[].obs;

  final List<ChatUser> searchList = [];

  bool isSearching = false;

  String email = '';

  void initState() {
    APIs.getSelfInfo();

    SystemChannels.lifecycle.setMessageHandler((message) {
      print('Message $message');

      if (APIs.auth.currentUser != null) {
        if (message.toString().contains('resume')) {
          APIs.updateActiveStatus(true);
        }
        if (message.toString().contains('pause')) {
          APIs.updateActiveStatus(false);
        }
      }
      return Future.value(message);
    });
  }

  Future<bool> onWillPop() {
    if (isSearching) {
      isSearching = !isSearching;

      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }

  addUser(String? value) async {
    Get.back();
    if (email.isNotEmpty) {
      await APIs.addChatUser(email.toString()).then((value) {
        if (!value) {
          Dialogs.showSnackbar('User does not Exists!');
        }
      });
    }
  }

  @override
  void onInit() {
    super.onInit();
    FirebaseFirestore.instance
        .collection('users')
        .snapshots()
        .listen((QuerySnapshot snapshot) {
      list.clear();
      snapshot.docs.forEach((DocumentSnapshot e) {
        // list.add(e.data());
      });
      print('Received data: ${list.toList()}');
    });
  }

  stream(snapshot) {
    APIs.getAllUsers(snapshot.data?.docs.map((e) => e.id).toList() ?? []);

    try {
      if (snapshot.hasData) {
        final data = snapshot.data?.docs;
        list = data?.map((e) => ChatUser.fromJson(e.data())).toList() ?? [];
      }
    } catch (e) {
      print(e);
    }
  }

  search(String? val) async {
    searchList.clear();
    for (var i in list) {
      if (i.name.toLowerCase().contains(val!.toLowerCase()) ||
          i.email.toLowerCase().contains(val.toLowerCase())) {
        searchList.add(i);
      }

      searchList;
    }
  }
}
