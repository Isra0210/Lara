import 'package:flutter/material.dart';
import 'package:lara/domain/repositories/theme_repository.dart';

class GetThemeUsecase {
  GetThemeUsecase(this.repository);
  final ThemeRepository repository;

  Future<ThemeMode> call() {
    return repository.getThemeMode();
  }
}
