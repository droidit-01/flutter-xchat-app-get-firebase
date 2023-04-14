import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:x_chat/models/chat_user.dart';

import '../../helper/my_date_util.dart';
import '../../main.dart';

class ViewProfileScreen extends StatelessWidget {
  final ChatUser user;
  const ViewProfileScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(Icons.arrow_back_ios),
            color: const Color(0xff147efb),
          ),
          title: Text(
            user.name,
            style: GoogleFonts.poppins(
                color: const Color(0xff147efb), fontWeight: FontWeight.w500),
          ),
        ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Joined On : ',
              style: GoogleFonts.poppins(
                color: const Color(0xff147efb),
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
            ),
            Text(
              MyDateUtil.getLastMessageTime(
                  context: context, time: user.createdAt, showYear: true),
              style: GoogleFonts.poppins(
                color: Colors.black54,
                fontSize: 16,
              ),
            )
          ],
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: mq.width * .05),
          child: Column(
            children: [
              SizedBox(
                width: mq.width,
                height: mq.height * .03,
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(mq.height * .1),
                child: CachedNetworkImage(
                  width: mq.height * .2,
                  height: mq.height * .2,
                  fit: BoxFit.cover,
                  imageUrl: user.image,
                  errorWidget: (context, url, error) => const CircleAvatar(
                    child: Icon(CupertinoIcons.person),
                  ),
                ),
              ),
              SizedBox(height: mq.height * .03),
              Text(
                user.email,
                style: GoogleFonts.poppins(
                  color: Colors.black87,
                  fontSize: 16,
                ),
              ),
              SizedBox(
                height: mq.height * .02,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'About : ',
                    style: GoogleFonts.poppins(
                      color: const Color(0xff147efb),
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    user.about,
                    style: GoogleFonts.poppins(
                      color: Colors.black54,
                      fontSize: 15,
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
