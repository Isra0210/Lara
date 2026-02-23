import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lara/core/ui/resources/app_icons.dart';
import 'package:lara/presentation/controller/chat_controller.dart';
import 'package:lara/presentation/pages/chat/widgets/bubble_message_widget.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  static const String route = '/chat';

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final controller = Get.find<ChatController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chat')),
      body: Column(
        children: [
          const Expanded(
            child: Column(
              children: [
                BubbleMessageWidget(
                  isUser: true,
                  message:
                      'Olá! Como posso ajudar? Olá! Como posso ajudar? Olá! Como posso ajudar?Olá! Como posso ajudar?Olá! Como posso ajudar?Olá! Como posso ajudar?',
                  time: '12:00',
                ),
                BubbleMessageWidget(
                  isUser: false,
                  message:
                      'Olá! Como posso ajudar? Olá! Como posso ajudar?Olá! Como posso ajudar?Olá! Como posso ajudar?',
                  time: '12:00',
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 22),
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller.messageController,
                    minLines: 1,
                    maxLines: 4,
                    keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.newline,
                    decoration: InputDecoration(
                      hintText: 'Pergunte alguma coisa...',
                      enabled: false,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      suffixIcon: IconButton(
                        style: IconButton.styleFrom(
                          foregroundColor: Theme.of(context).primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                          ),
                        ),
                        onPressed: () {},
                        icon: Icon(AppIcons.send),
                      ),
                    ),
                  ),
                ),
                // const SizedBox(width: 8),
                // IconButton(
                //   style: IconButton.styleFrom(
                //     backgroundColor: Theme.of(context).primaryColor,
                //     foregroundColor: Colors.white,
                //     shape: RoundedRectangleBorder(
                //       borderRadius: BorderRadius.circular(100),
                //     ),
                //   ),
                //   onPressed: () {},
                //   icon: Icon(AppIcons.send),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
