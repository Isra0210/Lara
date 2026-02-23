import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lara/core/ui/resources/app_icons.dart';
import 'package:lara/core/ui/resources/app_images.dart';
import 'package:lara/core/ui/ui.dart';
import 'package:lara/domain/entities/chat_entity.dart';
import 'package:lara/presentation/controller/chat_controller.dart';
import 'package:lara/presentation/controller/home_controller.dart';
import 'package:lara/presentation/pages/pages.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  static const String route = '/home';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final controller = Get.find<HomeController>();

  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
  }

  void _onScroll() {
    final scrolled =
        _scrollController.hasClients && _scrollController.offset > 0.5;
    if (scrolled != controller.isScrolled) {
      controller.setIsScrolled(scrolled);
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);

    final appBar = AppBar(
      title: const Text('Conversas'),
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      flexibleSpace: ClipRect(
        child: GetBuilder<HomeController>(
          builder: (controller) {
            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 160),
              child: controller.isScrolled
                  ? BackdropFilter(
                      key: const ValueKey('blur'),
                      filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                      child: Container(
                        color: theme.colorScheme.surface.withValues(
                          alpha: 0.55,
                        ),
                      ),
                    )
                  : Container(
                      key: const ValueKey('no_blur'),
                      color: Colors.transparent,
                    ),
            );
          },
        ),
      ),
      actions: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          margin: const EdgeInsets.only(right: 10),
          decoration: BoxDecoration(
            color: theme.colorScheme.onSurfaceVariant,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            spacing: 4,
            children: [
              IconButton(
                style: const ButtonStyle(visualDensity: VisualDensity.compact),
                onPressed: () => Get.toNamed(SettingsPage.route),
                icon: Icon(AppIcons.settings),
              ),
              IconButton(
                style: const ButtonStyle(visualDensity: VisualDensity.compact),
                onPressed: () => Get.toNamed(ChatPage.route),
                icon: Icon(AppIcons.plus),
              ),
            ],
          ),
        ),
      ],
    );

    void onDeleteChat(ChatEntity chat) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog.adaptive(
          title: Text(
            'Excluir conversa',
            style: theme.textTheme.bodyLarge!.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Tem certeza que deseja excluir esta conversa?',
              style: theme.textTheme.labelMedium,
            ),
          ),
          actions: [
            TextButton(
              onPressed: Get.back,
              child: Text('Cancelar', style: theme.textTheme.bodyMedium),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'Excluir',
                style: theme.textTheme.bodyMedium!.copyWith(
                  color: theme.colorScheme.error,
                ),
              ),
            ),
          ],
        ),
      );
    }

    final emptyMessage = Column(
      spacing: 40,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: size.width * 0.8,
              height: size.height * 0.36,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: theme.colorScheme.onSurfaceVariant,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 20,
                children: [
                  Image.asset(AppImages.noMessage, height: 140),
                  Center(
                    child: SizedBox(
                      width: size.width * 0.6,
                      child: Text(
                        'Nenhum chat ainda.\nComece um agora!',
                        style: theme.textTheme.titleMedium!.copyWith(
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: appBar,
      body: GetBuilder<ChatController>(
        builder: (controller) {
          if (controller.chats.isEmpty) return emptyMessage;

          return ListView.builder(
            itemCount: controller.chats.length,
            itemBuilder: (context, index) {
              return ChatCardWidget(
                isTyping: true,
                chat: controller.chats[index],
                onLongPress: () => onDeleteChat(controller.chats[index]),
                onTap: () {
                  Get.toNamed(ChatPage.route);
                },
              );
            },
            controller: _scrollController,
            padding: EdgeInsets.only(
              top: kToolbarHeight + MediaQuery.paddingOf(context).top,
            ),
          );
        },
      ),
    );
  }
}
