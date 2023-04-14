import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:x_chat/screens/chat/chat_screen.dart';
import 'package:x_chat/models/chat_user.dart';
import 'package:x_chat/screens/home/profile_dialog.dart';

import '../../API/apis.dart';
import '../../helper/my_date_util.dart';
import '../../main.dart';
import '../../models/message.dart';

class ChatUserCard extends StatelessWidget {
  final ChatUser user;
  ChatUserCard({super.key, required this.user});

  Message? message;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: mq.width * 0.04, vertical: 4),
      elevation: 0.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        onTap: () {
          Get.to(() => ChatScreen(user: user));
        },
        child: StreamBuilder(
          stream: APIs.getLastMessage(user),
          builder: (context, snapshot) {
            final data = snapshot.data?.docs;
            final list =
                data?.map((e) => Message.fromJson(e.data())).toList() ?? [];

            if (list.isNotEmpty) message = list[0];
            return ListTile(
              leading: InkWell(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (_) => ProfileDialog(user: user));
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(mq.height * .3),
                  child: CachedNetworkImage(
                    width: mq.height * .055,
                    height: mq.height * .055,
                    imageUrl: user.image,
                    placeholder: (context, url) =>
                        const CircularProgressIndicator(),
                    errorWidget: (context, url, error) => const CircleAvatar(
                      child: Icon(
                        CupertinoIcons.person,
                      ),
                    ),
                  ),
                ),
              ),
              title: Text(
                user.name,
                style: GoogleFonts.poppins(
                    color: const Color(0xff147efb),
                    fontWeight: FontWeight.w500),
              ),
              subtitle: Text(
                message != null
                    ? message!.type == Type.image
                        ? 'Photo'
                        : message!.msg
                    : user.about,
                maxLines: 1,
                style: GoogleFonts.poppins(),
              ),
              trailing: message == null
                  ? null
                  : message!.read.isEmpty && message!.fromId != APIs.user.uid
                      ? Container(
                          width: 15,
                          height: 15,
                          decoration: BoxDecoration(
                            color: const Color(0xff147efb),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        )
                      : Text(
                          MyDateUtil.getLastMessageTime(
                              context: context, time: message!.sent),
                          style: GoogleFonts.poppins(
                            color: Colors.black54,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
            );
          },
        ),
      ),
    );
  }
}
