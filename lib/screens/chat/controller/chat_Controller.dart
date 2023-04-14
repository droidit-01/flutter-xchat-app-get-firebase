import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:x_chat/API/apis.dart';
import 'package:x_chat/models/chat_user.dart';
import 'package:x_chat/models/message.dart';

class ChatController extends GetxController {
  final textController = TextEditingController();

  List<Message> list = [];

  bool showEmoji = false, isUploading = false;

  Future<bool> onwillPop() async {
    if (showEmoji) {
      showEmoji = !showEmoji;
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }

  emojiBtn(context) async {
    FocusScope.of(context).unfocus();

    showEmoji = !showEmoji;
  }

  onTap() async {
    if (showEmoji) showEmoji = !showEmoji;
  }

  imagePicker(ChatUser user) async {
    final ImagePicker picker = ImagePicker();

    final List<XFile> images = await picker.pickMultiImage(imageQuality: 70);

    for (var i in images) {
      print('Imaage path : ${i.path}');
      isUploading = true;
      await APIs.sendChatImage(user, File(i.path));
      isUploading = false;
    }
  }

  cameraPicker(ChatUser user) async {
    final ImagePicker picker = ImagePicker();

    final XFile? image =
        await picker.pickImage(source: ImageSource.camera, imageQuality: 70);
    if (image != null) {
      print('Imaage path : ${image.path}');
      isUploading = true;

      await APIs.sendChatImage(user, File(image.path));
      isUploading = false;
    }
  }

  sendBtn(ChatUser user) async {
    if (textController.text.isNotEmpty) {
      if (list.isEmpty) {
        APIs.sendFirstMessage(user, textController.text, Type.text);
      } else {
        APIs.sendMessage(user, textController.text, Type.text);
      }

      textController.text = '';
    }
  }
}
