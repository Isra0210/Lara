// domain/usecases/get_theme_usecase.dart
import 'package:flutter/material.dart';
import 'package:lara/domain/repositories/theme_repository.dart';


class GetThemeUseCase {
  GetThemeUseCase(this.repository);
  final ThemeRepository repository;

  Future<ThemeMode> call() {
    return repository.getThemeMode();
  }
}
