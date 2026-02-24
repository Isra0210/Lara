import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lara/core/ui/resources/app_icons.dart';
import 'package:lara/core/ui/resources/app_images.dart';
import 'package:lara/core/utils/time_utils.dart';
import 'package:lara/domain/entities/message_entity.dart';
import 'package:lara/presentation/controller/chat_controller.dart';
import 'package:lara/presentation/pages/chat/widgets/bubble_message_widget.dart';
import 'package:lara/presentation/pages/chat/widgets/loading_bubble.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  static const route = '/chat';

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final controller = Get.find<ChatController>();
  late final ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();

    ever(controller.messages, (_) => _scrollToBottom());
    ever(controller.isLoading, (_) => _scrollToBottom());
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(controller.chatTitle),
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: ClipRect(
          child: GetBuilder<ChatController>(
            builder: (controller) {
              return BackdropFilter(
                key: const ValueKey('blur'),
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: Container(
                  color: theme.colorScheme.surface.withValues(alpha: 0.55),
                ),
              );
            },
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: Obx(() {
                if (controller.messages.isEmpty) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 16,
                    children: [
                      SizedBox(
                        height: 100,
                        width: 100,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.asset(AppImages.logo, fit: BoxFit.cover),
                        ),
                      ),
                      Text(
                        'Como posso te ajudar?',
                        style: theme.textTheme.titleLarge!.copyWith(
                          fontWeight: FontWeight.w400,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  );
                }
                return ListView.builder(
                  controller: scrollController,
                  itemCount:
                      controller.messages.length +
                      (controller.isLoading.value ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (controller.isLoading.value &&
                        index == controller.messages.length) {
                      return const Padding(
                        padding: EdgeInsets.only(left: 16.0),
                        child: LoadingBubble(),
                      );
                    }
                    final message = controller.messages[index];
                    return BubbleMessageWidget(
                      isUser: message.role == MessageRole.user,
                      message: message.content,
                      time: TimeUtils.formatRelativeTime(message.createdAt),
                    );
                  },
                );
              }),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0, left: 16, right: 16),
            child: TextField(
              controller: controller.messageController,
              minLines: 1,
              maxLines: 4,
              keyboardType: TextInputType.multiline,
              textInputAction: TextInputAction.newline,
              decoration: InputDecoration(
                hintText: 'Pergunte alguma coisa...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                suffixIcon: IconButton(
                  style: IconButton.styleFrom(
                    foregroundColor: theme.iconTheme.color,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                  onPressed: () => controller.sendMessage(),
                  icon: Icon(AppIcons.send),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
