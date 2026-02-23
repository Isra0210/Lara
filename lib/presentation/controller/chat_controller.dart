import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lara/domain/entities/chat_entity.dart';

class ChatController extends GetxController {
  final messageController = TextEditingController();

  List<ChatEntity> chats = [];
  void setChats(List<ChatEntity> value) {
    chats = value;
    update();
  }
}
