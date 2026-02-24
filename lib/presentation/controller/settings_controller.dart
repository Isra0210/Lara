import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lara/domain/entities/chat_entity.dart';
import 'package:lara/domain/usecases/get_personality_usecase.dart';
import 'package:lara/domain/usecases/get_theme_usecase.dart';
import 'package:lara/domain/usecases/save_personality_usecase.dart';
import 'package:lara/domain/usecases/save_theme_usecase.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SettingsController extends GetxController {
  SettingsController({
    required this.getThemeUsecase,
    required this.saveThemeUsecase,
    required this.getPersonalityUsecase,
    required this.savePersonalityUsecase,
  });

  final GetThemeUsecase getThemeUsecase;
  final SaveThemeUsecase saveThemeUsecase;
  final GetPersonalityUsecase getPersonalityUsecase;
  final SavePersonalityUsecase savePersonalityUsecase;

  String appVersion = '1.0.0';

  Personality appPersonality = Personality.goodHumored;
  void setAppPersonality(Personality value) {
    appPersonality = value;
    savePersonalityUsecase(value);
    update();
  }

  ThemeMode appThemeMode = ThemeMode.system;
  void setAppThemeMode(ThemeMode value) {
    appThemeMode = value;
    update();
  }

  void setThemeMode(ThemeMode value) {
    setAppThemeMode(value);
    Get.changeThemeMode(value);
    saveThemeUsecase(value);
  }

  String getNameTheme(ThemeMode mode) {
    return switch (mode) {
      ThemeMode.dark => 'Escuro',
      ThemeMode.light => 'Claro',
      _ => 'Sistema',
    };
  }

  Future<void> initializeAppVersion() async {
    final info = await PackageInfo.fromPlatform();

    final version = info.version;
    final buildNumber = info.buildNumber;
    appVersion = '$version+$buildNumber';
    update();
  }

  Future<void> _loadSavedTheme() async {
    final mode = await getThemeUsecase();
    setAppThemeMode(mode);
    Get.changeThemeMode(mode);
  }

  Future<void> _loadSavedPersonality() async {
    final savedPersonality = await getPersonalityUsecase();
    setAppPersonality(savedPersonality);
  }

  String getPersonalityName(Personality personality) {
    return switch (personality) {
      Personality.ironic => 'Sarcástico / Irônico',
      Personality.formal => 'Mordomo Britânico / Formal',
      Personality.direct => 'Direto / Sem Rodeios (Modo Foco)',
      Personality.motivator => 'Motivador / Coach Positivo',
      Personality.nerd => 'Nerd / Especialista Geek',
      Personality.philosophical => 'Zen / Filosófico',
      _ => 'Bem humorada / Leve',
    };
  }

  @override
  void onInit() {
    super.onInit();
    initializeAppVersion();
    _loadSavedTheme();
    _loadSavedPersonality();
  }
}
