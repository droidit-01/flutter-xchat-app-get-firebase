import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:x_chat/screens/profile/profile_screen.dart';
import 'package:x_chat/screens/home/controller/homeController.dart';
import 'package:x_chat/screens/home/chat_user_card.dart';

import '../../API/apis.dart';
import '../../main.dart';
import '../../models/chat_user.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
        init: HomeController(),
        builder: (controller) {
          return GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: WillPopScope(
              onWillPop: controller.onWillPop,
              child: Scaffold(
                appBar: AppBar(
                  leading: const Icon(
                    CupertinoIcons.home,
                  ),
                  title: controller.isSearching
                      ? TextField(
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Name, Email, ... ',
                            hintStyle: GoogleFonts.poppins(
                                color: const Color(0xff147efb)),
                          ),
                          autofocus: true,
                          style: GoogleFonts.poppins(
                            fontSize: 17,
                            letterSpacing: 0.5,
                            color: const Color(0xff147efb),
                          ),
                          onChanged: (val) {
                            controller.search('');
                          },
                        )
                      : Text(
                          'X Chat ',
                          style: GoogleFonts.poppins(
                              color: const Color(0xff147efb),
                              fontWeight: FontWeight.w500),
                        ),
                  actions: [
                    IconButton(
                      onPressed: () {
                        setState(() {
                          controller.isSearching = !controller.isSearching;
                        });
                      },
                      icon: Icon(
                        controller.isSearching
                            ? CupertinoIcons.clear_circled_solid
                            : Icons.search,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Get.to(
                          () => ProfileScreen(user: APIs.me),
                        );
                      },
                      icon: const Icon(
                        Icons.more_vert,
                      ),
                    ),
                  ],
                ),
                floatingActionButton: Padding(
                  padding: const EdgeInsets.only(
                    bottom: 10,
                  ),
                  child: FloatingActionButton(
                    backgroundColor: const Color(0xff147efb),
                    onPressed: () {
                      _addChatUserDialog();
                    },
                    child: const Icon(
                      Icons.group,
                    ),
                  ),
                ),
                body: StreamBuilder(
                  stream: APIs.getMyUserId(),
                  builder: (context, snapshot) {
                    return StreamBuilder(
                      stream: APIs.getAllUsers(
                          snapshot.data?.docs.map((e) => e.id).toList() ?? []),
                      builder: (context, snapshot) {
                        try {
                          if (snapshot.hasData) {
                            final data = snapshot.data?.docs;
                            controller.list = data
                                    ?.map((e) => ChatUser.fromJson(e.data()))
                                    .toList() ??
                                [];
                          }
                        } catch (e) {
                          print(e);
                        }

                        if (controller.list.isNotEmpty) {
                          return ListView.builder(
                            itemCount: controller.isSearching
                                ? controller.searchList.length
                                : controller.list.length,
                            padding: EdgeInsets.only(top: mq.height * 0.01),
                            physics: const BouncingScrollPhysics(),
                            itemBuilder: (context, index) {
                              return ChatUserCard(
                                  user: controller.isSearching
                                      ? controller.searchList[index]
                                      : controller.list[index]);
                              // return Text('Name:${list[index]}');
                            },
                          );
                        } else {
                          return Center(
                            child: Text(
                              'No Connection Found!',
                              style: GoogleFonts.poppins(
                                fontSize: 20,
                              ),
                            ),
                          );
                        }
                      },
                    );
                  },
                ),
              ),
            ),
          );
        });
  }

  Future<void> _addChatUserDialog() async {
    final controller = Get.put(HomeController());

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        contentPadding: const EdgeInsets.only(
          left: 24,
          right: 24,
          top: 20,
          bottom: 10,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: const [
            Icon(
              Icons.person_add,
              color: Color(0xff147efb),
              size: 28,
            ),
            Text('   Add User'),
          ],
        ),
        content: TextFormField(
          maxLines: null,
          onChanged: (value) {
            controller.email = value;
          },
          decoration: InputDecoration(
            hintText: 'Email ID',
            hintStyle: GoogleFonts.poppins(),
            prefixIcon: const Icon(Icons.email, color: Color(0xff147efb)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ),
        actions: [
          MaterialButton(
            onPressed: () {
              Get.back();
            },
            child: Text(
              'Cancel',
              style: GoogleFonts.poppins(
                color: const Color(0xff147efb),
                fontSize: 16,
              ),
            ),
          ),
          MaterialButton(
            onPressed: () {
              controller.addUser('');
            },
            child: Text(
              'Add',
              style: GoogleFonts.poppins(
                color: const Color(0xff147efb),
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
