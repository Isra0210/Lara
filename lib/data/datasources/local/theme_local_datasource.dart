import 'package:shared_preferences/shared_preferences.dart';

class ThemeLocalDatasource {
  static const key = 'theme_mode';

  Future<String?> getCachedTheme() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  Future<void> cacheTheme(String themeName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, themeName);
  }
}
