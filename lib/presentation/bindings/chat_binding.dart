import 'package:get/get.dart';
import 'package:lara/presentation/controller/chat_controller.dart';

class ChatBinding implements Bindings{
  @override
  void dependencies() {
    Get.put(ChatController(), permanent: true);
  }
}