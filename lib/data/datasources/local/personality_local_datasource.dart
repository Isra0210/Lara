import 'package:shared_preferences/shared_preferences.dart';

class PersonalityLocalDatasource {
  static const key = 'ai_personality';

  Future<String?> getCachedPersonality() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  Future<void> cachePersonality(String personalityName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, personalityName);
  }
}
