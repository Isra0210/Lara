import 'dart:convert';
import 'package:lara/data/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthLocalDataSource {
  static const _kUserKey = 'cached_user';

  Future<void> cacheUser(Map<String, dynamic> user) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(user);
    await prefs.setString(_kUserKey, jsonString);
  }

  Future<UserModel?> getCachedUser() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_kUserKey);
    if (jsonString == null) return null;

    final Map<String, dynamic> jsonMap = jsonDecode(jsonString);
    return UserModel.fromCache(jsonMap);
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kUserKey);
  }
}
