import 'package:flutter/material.dart';
import 'package:lara/data/datasources/local/theme_local_datasource.dart';
import 'package:lara/domain/repositories/theme_repository.dart';

class ThemeRepositoryImpl implements ThemeRepository {
  ThemeRepositoryImpl({required this.localDataSource});

  final ThemeLocalDatasource localDataSource;

  @override
  Future<ThemeMode> getThemeMode() async {
    final themeString = await localDataSource.getCachedTheme();

    return switch (themeString) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
  }

  @override
  Future<void> saveThemeMode(ThemeMode mode) async {
    await localDataSource.cacheTheme(mode.name);
  }
}
