import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:intl/intl.dart';
import 'package:lara/core/ui/resources/app_images.dart';
import 'package:lara/domain/entities/chat_entity.dart';
import 'package:lara/presentation/controller/home_controller.dart';

class ChatCardWidget extends GetView<HomeController> {
  const ChatCardWidget({
    required this.chat,
    required this.isSynced,
    this.onTap,
    super.key,
  });

  final ChatEntity chat;
  final bool isSynced;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final leading = Container(
      width: 50,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: theme.colorScheme.surfaceContainerHighest,
      ),
      clipBehavior: Clip.antiAlias,
      child: Image.asset(
        AppImages.logo,
        width: 52,
        height: 52,
        fit: BoxFit.cover,
      ),
    );

    return Column(
      children: [
        ListTile(
          onTap: onTap,
          visualDensity: VisualDensity.compact,
          leading: leading,
          title: Text(
            chat.title,
            style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 6.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (chat.lastMessage != null)
                  Text(
                    chat.lastMessage!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                if (chat.updatedAt != null && chat.lastMessage == null)
                  Text(
                    DateFormat('dd/MM/yyyy HH:mm').format(chat.updatedAt!),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSecondary,
                    ),
                  ),
              ],
            ),
          ),
          trailing: isSynced
              ? Icon(
                  Icons.cloud_done,
                  color: theme.colorScheme.onSurface,
                  size: 16,
                )
              : const Icon(Icons.cloud_off, size: 16),
        ),
        Divider(
          indent: 20,
          endIndent: 20,
          height: 4,
          thickness: 0.8,
          color: theme.colorScheme.onSecondary.withValues(alpha: 0.1),
        ),
      ],
    );
  }
}
