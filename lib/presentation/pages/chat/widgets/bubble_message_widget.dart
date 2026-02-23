import 'package:flutter/material.dart';

class BubbleMessageWidget extends StatelessWidget {
  const BubbleMessageWidget({
    required this.isUser,
    required this.message,
    required this.time,
    super.key,
  });

  final bool isUser;
  final String message;
  final String time;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        constraints: const BoxConstraints(maxWidth: 300),
        decoration: BoxDecoration(
          color: isUser
              ? theme.colorScheme.onInverseSurface
              : theme.colorScheme.onSurface,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isUser ? 16 : 4),
            bottomRight: Radius.circular(isUser ? 4 : 16),
          ),
        ),
        child: Column(
          crossAxisAlignment: isUser
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            Text(
              message,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: isUser
                    ? theme.colorScheme.onPrimary
                    : theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              time,
              style: theme.textTheme.labelSmall?.copyWith(
                fontSize: 10,
                color:
                    (isUser
                            ? theme.colorScheme.onPrimary
                            : theme.colorScheme.onSurfaceVariant)
                        .withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
