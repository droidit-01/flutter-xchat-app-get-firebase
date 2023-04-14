import 'dart:io';

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:x_chat/API/apis.dart';
import 'package:x_chat/models/chat_user.dart';

import 'package:x_chat/screens/chat/controller/chat_Controller.dart';
import 'package:x_chat/screens/chat/customAppBar.dart';
import 'package:x_chat/screens/chat/message_card.dart';

import '../../main.dart';
import '../../models/message.dart';

class ChatScreen extends StatefulWidget {
  final ChatUser user;
  const ChatScreen({super.key, required this.user});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChatController>(
      init: ChatController(),
      builder: (controller) => GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
          child: WillPopScope(
            onWillPop: controller.onwillPop,
            child: Scaffold(
              appBar: AppBar(
                elevation: 0,
                automaticallyImplyLeading: false,
                flexibleSpace: CustomAppBar(user: widget.user),
              ),
              backgroundColor: const Color(0xFFFFFFFF),
              body: Column(
                children: [
                  Expanded(
                    child: StreamBuilder(
                      stream: APIs.getAllMessages(widget.user),
                      builder: (context, snapshot) {
                        final data = snapshot.data?.docs;
                        controller.list = data
                                ?.map((e) => Message.fromJson(e.data()))
                                .toList() ??
                            [];

                        if (controller.list.isNotEmpty) {
                          return ListView.builder(
                              itemCount: controller.list.length,
                              reverse: true,
                              padding: EdgeInsets.only(top: mq.height * .01),
                              physics: const BouncingScrollPhysics(),
                              itemBuilder: (context, index) {
                                return MessageCard(
                                  message: controller.list[index],
                                );
                              });
                        } else {
                          return Center(
                            child: Text(
                              'Say Hii ! 👋',
                              style: GoogleFonts.poppins(
                                fontSize: 20,
                                color: const Color(0xff147efb),
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                  if (controller.isUploading)
                    const Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 20,
                        ),
                        child: CircularProgressIndicator(
                          color: Color(0xff147efb),
                        ),
                      ),
                    ),
                  _chatInput(),
                  if (controller.showEmoji)
                    SizedBox(
                      height: mq.height * .35,
                      child: EmojiPicker(
                        textEditingController: controller.textController,
                        config: Config(
                          bgColor: Colors.white,
                          columns: 8,
                          initCategory: Category.RECENT,
                          emojiSizeMax: 32 * (Platform.isIOS ? 1.30 : 1.0),
                        ),
                      ),
                    )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _chatInput() {
    final controller = Get.put(ChatController());
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: mq.height * .01,
        horizontal: mq.width * .03,
      ),
      child: Row(
        children: [
          Expanded(
            child: Card(
              shape: const StadiumBorder(),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => controller.emojiBtn(context),
                    icon: const Icon(
                      Icons.emoji_emotions,
                      color: Color(0xff147efb),
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      controller: controller.textController,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      onTap: controller.onTap,
                      decoration: InputDecoration(
                        hintText: 'Message...',
                        hintStyle: GoogleFonts.poppins(
                          color: const Color(0xff147efb),
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => controller.imagePicker(widget.user),
                    icon: const Icon(
                      Icons.image,
                      color: Color(0xff147efb),
                    ),
                  ),
                  IconButton(
                    onPressed: () => controller.cameraPicker(widget.user),
                    icon: const Icon(
                      Icons.camera_alt_rounded,
                      color: Color(0xff147efb),
                    ),
                  ),
                  SizedBox(
                    width: mq.width * .02,
                  ),
                ],
              ),
            ),
          ),
          MaterialButton(
            onPressed: () => controller.sendBtn(widget.user),
            padding:
                const EdgeInsets.only(top: 10, bottom: 10, right: 5, left: 10),
            minWidth: 0,
            shape: const CircleBorder(),
            color: const Color(0xff147efb),
            child: const Icon(
              Icons.send,
              color: Colors.white,
              size: 26,
            ),
          ),
        ],
      ),
    );
  }
}
