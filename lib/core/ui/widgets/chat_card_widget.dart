import 'package:flutter/material.dart';
import 'package:lara/core/ui/resources/app_images.dart';
import 'package:lara/core/utils/time_utils.dart';
import 'package:lara/domain/entities/chat_entity.dart';

class ChatCardWidget extends StatelessWidget {
  const ChatCardWidget({
    required this.chat,
    this.onTap,
    this.onLongPress,
    this.isTyping = false,
    super.key,
  });

  final ChatEntity chat;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final bool isTyping;

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
          onLongPress: onLongPress,
          visualDensity: VisualDensity.compact,
          leading: leading,
          title: Text(
            chat.title,
            style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(right: 4.0),
            child: isTyping
                ? Text(
                    'Digitando...',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface,
                    ),
                  )
                : Text(
                    chat.lastMessage?.content ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSecondary,
                    ),
                  ),
          ),
          trailing: chat.lastMessage?.createdAt != null
              ? Text(
                  TimeUtils.formatRelativeTime(chat.lastMessage!.createdAt),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSecondary,
                    fontWeight: FontWeight.w500,
                    fontSize: 10,
                  ),
                )
              : null,
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
