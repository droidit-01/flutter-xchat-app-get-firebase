import 'package:get/get.dart';
import 'package:x_chat/models/message.dart';

class CardController extends GetxController {
  Message? message;

  void stream(snapshot) {
    final data = snapshot.data?.docs;
    final list = data?.map((e) => Message.fromJson(e.data())).toList() ?? [];
  }
}
