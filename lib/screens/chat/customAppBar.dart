import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:x_chat/API/apis.dart';
import 'package:x_chat/helper/my_date_util.dart';
import 'package:x_chat/main.dart';
import 'package:x_chat/screens/view_profile/view_profile_screen.dart';

import '../../models/chat_user.dart';

class CustomAppBar extends StatelessWidget {
  final ChatUser user;
  const CustomAppBar({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 3),
      child: InkWell(
        onTap: () {
          Get.to(() => ViewProfileScreen(user: user));
        },
        child: StreamBuilder(
          stream: APIs.getUserInfo(user),
          builder: (context, snapshot) {
            final data = snapshot.data?.docs;
            final list =
                data?.map((e) => ChatUser.fromJson(e.data())).toList() ?? [];

            return Row(
              children: [
                IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    color: Color(0xff147efb),
                  ),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(mq.height * .03),
                  child: CachedNetworkImage(
                    width: mq.height * .05,
                    height: mq.height * .05,
                    imageUrl: list.isNotEmpty ? list[0].image : user.image,
                    errorWidget: (context, url, error) => const CircleAvatar(
                      child: Icon(
                        CupertinoIcons.person,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      list.isNotEmpty ? list[0].name : user.name,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: const Color(0xff147efb),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    Text(
                      list.isNotEmpty
                          ? list[0].isOnline
                              ? 'Online'
                              : MyDateUtil.getLastActiveTime(
                                  context: context,
                                  lastActive: list[0].lastActive)
                          : MyDateUtil.getLastActiveTime(
                              context: context, lastActive: user.lastActive),
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
