import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lara/presentation/controller/settings_controller.dart';

class CopyrightWidget extends GetView<SettingsController> {
  const CopyrightWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 22.0),
            child: Column(
              children: [
                Row(
                  spacing: 2,
                  children: [
                    const Icon(Icons.copyright, size: 12),
                    Text(
                      '${DateTime.now().year} Lara',
                      style: theme.textTheme.labelMedium,
                    ),
                  ],
                ),
                Text(
                  'v${controller.appVersion}',
                  style: theme.textTheme.labelMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
