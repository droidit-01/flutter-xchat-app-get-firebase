import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:x_chat/API/apis.dart';
import 'package:x_chat/screens/profile/controller/profileController.dart';

import '../../main.dart';
import '../../models/chat_user.dart';

class ProfileScreen extends StatefulWidget {
  final ChatUser user;
  const ProfileScreen({super.key, required this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(
        init: ProfileController(),
        builder: (controller) {
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: const Text('User Profile'),
            ),
            floatingActionButton: Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: FloatingActionButton.extended(
                backgroundColor: Colors.redAccent,
                onPressed: controller.floatingBtnPress,
                icon: const Icon(Icons.logout),
                label: Text(
                  'Logout',
                  style: GoogleFonts.poppins(),
                ),
              ),
            ),
            body: Form(
              key: controller.formkey,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: mq.width * .05),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        width: mq.width,
                        height: mq.height * .03,
                      ),
                      Stack(
                        children: [
                          controller.images != null
                              ? ClipRRect(
                                  borderRadius:
                                      BorderRadius.circular(mq.height * .1),
                                  child: Image.file(
                                    File(controller.images.toString()),
                                    width: mq.height * .2,
                                    height: mq.height * .2,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : ClipRRect(
                                  borderRadius:
                                      BorderRadius.circular(mq.height * .1),
                                  child: CachedNetworkImage(
                                    width: mq.height * .2,
                                    height: mq.height * .2,
                                    fit: BoxFit.cover,
                                    imageUrl: widget.user.image,
                                    errorWidget: (context, url, error) =>
                                        const CircleAvatar(
                                      child: Icon(
                                        CupertinoIcons.person,
                                        size: 30,
                                      ),
                                    ),
                                  ),
                                ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: MaterialButton(
                              onPressed: () {
                                _showBottomSheet();
                              },
                              elevation: 3,
                              shape: const CircleBorder(),
                              color: Colors.white,
                              child: const Icon(
                                Icons.edit,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: mq.height * .03,
                      ),
                      Text(
                        widget.user.email,
                        style: GoogleFonts.poppins(
                          color: Colors.black54,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(
                        height: mq.height * .05,
                      ),
                      TextFormField(
                        initialValue: widget.user.name,
                        onSaved: (val) => APIs.me.name = val ?? '',
                        validator: (val) => val != null && val.isNotEmpty
                            ? null
                            : 'Required Field',
                        style: GoogleFonts.poppins(),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          prefixIcon: const Icon(
                            Icons.person,
                            color: Colors.blue,
                          ),
                          hintText: 'eg. Happy Singh',
                          hintStyle: GoogleFonts.poppins(),
                          label: const Text('Name'),
                        ),
                      ),
                      SizedBox(
                        height: mq.height * .02,
                      ),
                      TextFormField(
                        initialValue: widget.user.about,
                        onSaved: (val) => APIs.me.about = val ?? '',
                        validator: (val) => val != null && val.isNotEmpty
                            ? null
                            : 'Required Field',
                        style: GoogleFonts.poppins(),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          prefixIcon: const Icon(
                            Icons.info_outline,
                            color: Colors.blue,
                          ),
                          hintText: 'eg. Feeling happy !',
                          hintStyle: GoogleFonts.poppins(),
                          label: const Text(
                            'About',
                          ),
                        ),
                      ),
                      SizedBox(
                        height: mq.height * .05,
                      ),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                            shape: const StadiumBorder(),
                            minimumSize: Size(
                              mq.width * .5,
                              mq.height * .06,
                            )),
                        onPressed: controller.updateBtn,
                        icon: const Icon(
                          Icons.edit,
                          size: 28,
                        ),
                        label: Text(
                          'UPDATE',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  void _showBottomSheet() {
    final controller = Get.put(ProfileController());
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        builder: (_) {
          return ListView(
            shrinkWrap: true,
            padding:
                EdgeInsets.only(top: mq.height * .03, bottom: mq.height * .05),
            children: [
              Text(
                'Pick Profile Picture',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(
                height: mq.height * .01,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: const CircleBorder(),
                      fixedSize: Size(mq.width * .2, mq.height * .11),
                    ),
                    onPressed: () {
                      controller.galleryPicker(widget.user);
                    },
                    child: Image.asset('assets/gallary.png'),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: const CircleBorder(),
                      fixedSize: Size(mq.width * .2, mq.height * .11),
                    ),
                    onPressed: () {
                      controller.cameraPicker(widget.user);
                    },
                    child: Image.asset('assets/camara.png'),
                  ),
                ],
              ),
            ],
          );
        });
  }
}
