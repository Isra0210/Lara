import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lara/core/ui/overlays/snackbar_overlay.dart';
import 'package:lara/domain/entities/message_entity.dart';
import 'package:lara/domain/usecases/get_messages_usecase.dart';
import 'package:lara/domain/usecases/send_message_usecase.dart';
import 'package:lara/presentation/controller/settings_controller.dart';
import 'package:uuid/uuid.dart';

class ChatController extends GetxController {
  ChatController(this._sendMessage, this._getMessages, this.settings);

  final SendMessageUsecase _sendMessage;
  final GetMessagesUsecase _getMessages;
  final SettingsController settings;

  final messages = <MessageEntity>[].obs;
  final isLoading = false.obs;
  late String chatId;
  late String chatTitle;
  final _uuid = const Uuid();

  final messageController = TextEditingController();

  bool isScrolled = false;
  void setIsScrolled(bool value) {
    isScrolled = value;
    update();
  }

  Future<void> loadMessages() async {
    final result = await _getMessages(chatId);
    messages.assignAll(result);
  }

  Future<void> sendMessage() async {
    final text = messageController.text;
    if (text.trim().isEmpty || isLoading.value) return;

    final userMsg = MessageEntity(
      id: _uuid.v4(),
      chatId: chatId,
      content: text.trim(),
      role: MessageRole.user,
      status: MessageStatus.sent,
      createdAt: DateTime.now(),
    );
    messages.add(userMsg);
    isLoading.value = true;
    messageController.clear();

    final history = List<MessageEntity>.from(messages);

    try {
      final aiMessage = await _sendMessage(
        userMessage: userMsg,
        history: history,
        personality: settings.getPersonalityName(settings.appPersonality),
      );

      messages.add(aiMessage);
    } catch (e) {
      SnackbarOverlay.error(text);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>;
    chatId = args['chatId'] as String;
    chatTitle = args['title'] as String;
    loadMessages();
  }
}
