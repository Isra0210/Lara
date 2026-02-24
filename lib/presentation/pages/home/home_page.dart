import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lara/core/ui/resources/app_icons.dart';
import 'package:lara/core/ui/ui.dart';
import 'package:lara/domain/entities/chat_entity.dart';
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
    // final size = MediaQuery.of(context).size;
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
              child: BackdropFilter(
                key: const ValueKey('blur'),
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: Container(
                  color: theme.colorScheme.surface.withValues(alpha: 0.55),
                ),
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
                onPressed: controller.createNewChat,
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
                Get.back();
                controller.deleteChat(chat.id);
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

    final emptyMessage = Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.chat_bubble_outline, size: 100),
          const SizedBox(height: 16),
          Text(
            'Nenhuma conversa ainda',
            style: theme.textTheme.titleMedium!.copyWith(
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Toque no + para começar',
            style: theme.textTheme.titleMedium!.copyWith(
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: appBar,
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator.adaptive());
        }
        if (controller.chats.isEmpty) return emptyMessage;

        return RefreshIndicator(
          onRefresh: controller.loadChats,
          child: ListView.builder(
            itemCount: controller.chats.length,
            itemBuilder: (context, index) {
              final chat = controller.chats[index];
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                margin: const EdgeInsets.only(top: 8),
                child: Dismissible(
                  key: Key(chat.id),
                  confirmDismiss: (_) async {
                    onDeleteChat(chat);
                    return false;
                  },
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.error,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      Icons.delete,
                      color: theme.scaffoldBackgroundColor,
                    ),
                  ),
                  child: ChatCardWidget(
                    isSynced: controller.chats[index].syncedToFirebase,
                    chat: chat,
                    onTap: () => controller.openChat(chat),
                  ),
                ),
              );
            },
            controller: _scrollController,
            padding: EdgeInsets.only(
              top: kToolbarHeight + MediaQuery.paddingOf(context).top,
            ),
          ),
        );
      }),
    );
  }
}
