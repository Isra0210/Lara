import 'package:flutter/material.dart';
import 'package:lara/domain/repositories/theme_repository.dart';

class SaveThemeUseCase {
  SaveThemeUseCase(this.repository);
  final ThemeRepository repository;

  Future<void> call(ThemeMode mode) {
    return repository.saveThemeMode(mode);
  }
}
