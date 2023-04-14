import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:x_chat/API/apis.dart';
import 'package:x_chat/helper/dialogs.dart';
import 'package:x_chat/models/message.dart';

import '../../helper/my_date_util.dart';
import '../../main.dart';

class MessageCard extends StatefulWidget {
  const MessageCard({super.key, required this.message});

  final Message message;

  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  @override
  Widget build(BuildContext context) {
    bool isMe = APIs.user.uid == widget.message.fromId;

    return InkWell(
      onLongPress: () {
        _showBottomSheet(isMe);
      },
      child: isMe ? _greenMessage() : _blueeMessage(),
    );
  }

  Widget _blueeMessage() {
    if (widget.message.read.isEmpty) {
      APIs.updateMessageReadStatus(widget.message);
      print('message read updated');
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Container(
            padding: EdgeInsets.all(widget.message.type == Type.image
                ? mq.height * .00
                : mq.width * .03),
            margin: EdgeInsets.symmetric(
              horizontal: mq.width * .04,
              vertical: mq.height * .01,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFBBBBBB),
              border: Border.all(color: Colors.grey.withOpacity(.2)),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: widget.message.type == Type.text
                ? Text(
                    widget.message.msg,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: CachedNetworkImage(
                      placeholder: (context, url) => const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      ),
                      imageUrl: widget.message.msg,
                      errorWidget: (context, url, error) => const CircleAvatar(
                        child: Icon(
                          Icons.image,
                          size: 70,
                        ),
                      ),
                    ),
                  ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(right: mq.width * .04),
          child: Text(
            MyDateUtil.getFormattedTime(
              context: context,
              time: widget.message.sent,
            ),
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: Colors.black54,
            ),
          ),
        ),
      ],
    );
  }

  Widget _greenMessage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            SizedBox(
              width: mq.width * .04,
            ),
            if (widget.message.read.isNotEmpty)
              const Icon(
                Icons.done_all_rounded,
                color: Color(0xff147efb),
                size: 20,
              ),
            const SizedBox(
              width: 2,
            ),
            Text(
              MyDateUtil.getFormattedTime(
                context: context,
                time: widget.message.sent,
              ),
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: Colors.black54,
              ),
            ),
          ],
        ),
        Flexible(
          child: Container(
            padding: EdgeInsets.all(widget.message.type == Type.image
                ? mq.width * .00
                : mq.width * .03),
            margin: EdgeInsets.symmetric(
              horizontal: mq.width * .04,
              vertical: mq.height * .01,
            ),
            decoration: BoxDecoration(
              color: const Color(0xff147efb),
              border:
                  Border.all(color: const Color(0xff147efb).withOpacity(.2)),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
                bottomLeft: Radius.circular(20),
              ),
            ),
            child: widget.message.type == Type.text
                ? Text(
                    widget.message.msg,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: CachedNetworkImage(
                      placeholder: (context, url) => const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      ),
                      imageUrl: widget.message.msg,
                      errorWidget: (context, url, error) => const CircleAvatar(
                        child: Icon(
                          Icons.image,
                          size: 70,
                        ),
                      ),
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  void _showBottomSheet(bool isMe) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFFF3F2F2),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (_) {
        return ListView(
          shrinkWrap: true,
          children: [
            Container(
              height: 4,
              margin: EdgeInsets.symmetric(
                vertical: mq.height * .015,
                horizontal: mq.width * .4,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFF8A8A8A),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            widget.message.type == Type.text
                ? _OptionItem(
                    icon: const Icon(Icons.copy_all_rounded,
                        color: Color(0xff147efb), size: 26),
                    name: 'Copy Text',
                    onTap: () async {
                      await Clipboard.setData(
                              ClipboardData(text: widget.message.msg))
                          .then((value) {
                        Navigator.pop(context);

                        Dialogs.showSnackbar('Text Copied!');
                      });
                    },
                  )
                : _OptionItem(
                    icon: const Icon(Icons.download_rounded,
                        color: Color(0xff147efb), size: 26),
                    name: 'Save Image',
                    onTap: () async {
                      try {
                        print('Image url : ${widget.message.msg}');
                        await GallerySaver.saveImage(widget.message.msg,
                                albumName: 'xchat')
                            .then((success) {
                          Navigator.pop(context);
                          if (success != null && success) {
                            Dialogs.showSnackbar('Image Successfully Saved!');
                          }
                        });
                      } catch (e) {
                        print('ErrorwhileSavingImg : $e');
                      }
                    },
                  ),
            if (isMe)
              Divider(
                color: Colors.black54,
                endIndent: mq.width * .04,
                indent: mq.width * .04,
              ),
            if (widget.message.type == Type.text && isMe)
              _OptionItem(
                icon:
                    const Icon(Icons.edit, color: Color(0xff147efb), size: 26),
                name: 'Edit Message',
                onTap: () {
                  Navigator.pop(context);

                  _showMessageUpdateDialog();
                },
              ),
            if (isMe)
              _OptionItem(
                icon: const Icon(Icons.delete, color: Colors.red, size: 26),
                name: 'Delete Message',
                onTap: () async {
                  var delete =
                      await APIs.deleteMessage(widget.message).then((value) {
                    Navigator.pop(context);
                  });
                },
              ),
            Divider(
              color: Colors.black54,
              endIndent: mq.width * .04,
              indent: mq.width * .04,
            ),
            _OptionItem(
              icon: const Icon(Icons.remove_red_eye,
                  color: Color(0xff147efb), size: 26),
              name:
                  'Sent At : ${MyDateUtil.getMessageTime(context: context, time: widget.message.sent)}',
              onTap: () {},
            ),
            _OptionItem(
              icon: const Icon(Icons.remove_red_eye,
                  color: Color(0xFF429945), size: 26),
              name: widget.message.read.isEmpty
                  ? 'Read At : Not seen yet'
                  : 'Read At : ${MyDateUtil.getMessageTime(context: context, time: widget.message.read)}',
              onTap: () {},
            ),
          ],
        );
      },
    );
  }

  void _showMessageUpdateDialog() {
    String updateMsg = widget.message.msg;

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
          children: [
            const Icon(
              Icons.message,
              color: Color(0xff147efb),
              size: 28,
            ),
            Text(
              '  Update Message',
              style: GoogleFonts.poppins(),
            ),
          ],
        ),
        content: TextFormField(
          initialValue: updateMsg,
          style: GoogleFonts.poppins(),
          maxLines: null,
          onChanged: (value) => updateMsg = value,
          decoration: InputDecoration(
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(20))),
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
              Get.back();
              APIs.updateMessage(widget.message, updateMsg);
            },
            child: Text(
              'Update',
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

class _OptionItem extends StatelessWidget {
  final Icon icon;
  final String name;
  final VoidCallback onTap;
  const _OptionItem(
      {required this.icon, required this.name, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(),
      child: Padding(
        padding: EdgeInsets.only(
          left: mq.width * .05,
          top: mq.height * .015,
          bottom: mq.height * .015,
        ),
        child: Row(
          children: [
            icon,
            Flexible(
              child: Text(
                '    $name',
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  color: Colors.black54,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
