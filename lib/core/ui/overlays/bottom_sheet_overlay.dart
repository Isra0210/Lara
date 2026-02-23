import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BottomSheetAction {
  BottomSheetAction({required this.title, required this.onPressed});

  final String title;
  final VoidCallback onPressed;
}

class BottomSheetOverlay {
  static void show({
    required BuildContext context,
    String? title,
    required List<BottomSheetAction> actions,
    BottomSheetAction? cancelAction,
  }) {
    final theme = Theme.of(context);

    if (Platform.isIOS) {
      showCupertinoModalPopup(
        context: context,
        builder: (context) => CupertinoActionSheet(
          title: title != null ? Text(title) : null,
          actions: [
            ...actions.map(
              (action) => CupertinoActionSheetAction(
                onPressed: action.onPressed,
                child: Text(action.title, style: theme.textTheme.bodyMedium),
              ),
            ),
          ],
          cancelButton: cancelAction != null
              ? CupertinoActionSheetAction(
                  isDefaultAction: true,
                  onPressed: cancelAction.onPressed,
                  child: Text(
                    cancelAction.title,
                    style: theme.textTheme.bodyMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              : null,
        ),
      );
    } else {
      showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        builder: (context) => SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (title != null)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    title,
                    style: theme.textTheme.titleMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ...actions.map(
                (action) => ListTile(
                  title: Text(
                    action.title,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium!.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  onTap: () {
                    Get.back();
                    action.onPressed();
                  },
                ),
              ),
              if (cancelAction != null) ...[
                const Divider(),
                ListTile(
                  title: Text(
                    cancelAction.title,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: () {
                    Get.back();
                    cancelAction.onPressed();
                  },
                ),
              ],
            ],
          ),
        ),
      );
    }
  }
}
