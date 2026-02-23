import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lara/domain/entities/chat_entity.dart';
import 'package:lara/presentation/controller/settings_controller.dart';

class PersonalityDialog extends StatelessWidget {
  const PersonalityDialog({
    required this.chatPersonality,
    required this.systemPersonality,
    required this.settings,
    super.key,
  });

  final Personality chatPersonality;
  final Personality systemPersonality;
  final SettingsController settings;

  @override
  Widget build(BuildContext context) {
    return AlertDialog.adaptive(
      title: const Text('Personalidade diferente'),
      content: Text(
        'Essa conversa foi criada com "${settings.getPersonalityName(chatPersonality)}". '
        'Sua preferência atual é "${settings.getPersonalityName(systemPersonality)}".\n\n'
        'Qual você quer usar?',
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(result: chatPersonality),
          child: Text('Manter do chat (${chatPersonality.name})'),
        ),
        FilledButton(
          onPressed: () => Get.back(result: systemPersonality),
          child: Text('Usar do sistema (${systemPersonality.name})'),
        ),
      ],
    );
  }
}
