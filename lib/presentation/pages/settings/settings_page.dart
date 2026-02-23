import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lara/core/ui/overlays/bottom_sheet_overlay.dart';
import 'package:lara/domain/entities/chat_entity.dart';
import 'package:lara/presentation/controller/auth_controller.dart';
import 'package:lara/presentation/controller/settings_controller.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  static const route = '/settings';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final controller = Get.find<SettingsController>();
    final authController = Get.find<AuthController>();

    return Scaffold(
      appBar: AppBar(title: const Text('Configurações')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Column(
                children: [
                  ListTile(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16.0),
                        topRight: Radius.circular(16.0),
                      ),
                    ),
                    title: const Text('Tema do app'),
                    trailing: const Icon(CupertinoIcons.chevron_forward),
                    subtitle: GetBuilder<SettingsController>(
                      builder: (controller) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            controller.getNameTheme(controller.appThemeMode),
                            style: theme.textTheme.labelSmall!.copyWith(
                              color: theme.colorScheme.onSecondary,
                            ),
                          ),
                        );
                      },
                    ),
                    onTap: () {
                      BottomSheetOverlay.show(
                        context: context,
                        actions: [
                          ...ThemeMode.values.map(
                            (mode) => BottomSheetAction(
                              title: controller.getNameTheme(mode),
                              onPressed: () {
                                Get.back();
                                controller.setThemeMode(mode);
                              },
                            ),
                          ),
                        ],
                        cancelAction: BottomSheetAction(
                          title: 'Cancelar',
                          onPressed: () {
                            Get.back();
                          },
                        ),
                      );
                    },
                  ),
                  const Divider(height: 0),
                  ListTile(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(16.0),
                        bottomRight: Radius.circular(16.0),
                      ),
                    ),
                    subtitle: GetBuilder<SettingsController>(
                      builder: (controller) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            controller.getPersonalityName(
                              controller.appPersonality,
                            ),
                            style: theme.textTheme.labelSmall!.copyWith(
                              color: theme.colorScheme.onSecondary,
                            ),
                          ),
                        );
                      },
                    ),
                    title: const Text('Personalidade'),
                    trailing: const Icon(CupertinoIcons.chevron_forward),
                    onTap: () {
                      BottomSheetOverlay.show(
                        context: context,
                        actions: [
                          ...Personality.values.map(
                            (personality) => BottomSheetAction(
                              title: controller.getPersonalityName(personality),
                              onPressed: () {
                                Get.back();
                                controller.setAppPersonality(personality);
                              },
                            ),
                          ),
                        ],
                        cancelAction: BottomSheetAction(
                          title: 'Cancelar',
                          onPressed: () {
                            Get.back();
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 40.0),
              child: OutlinedButton(
                onPressed: authController.logout,
                child: Text(
                  'Sair do app',
                  style: theme.textTheme.titleSmall!.copyWith(
                    color: theme.colorScheme.error,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
