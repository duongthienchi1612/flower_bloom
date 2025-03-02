import 'dart:convert';

import 'package:flower_bloom/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GameStorage {
  static const String _keyLevelData = PreferenceKey.levelData;

  Future<void> initGameData(int totalLevels) async {
    final prefs = await SharedPreferences.getInstance();
    String? data = prefs.getString(_keyLevelData);

    if (data == null) {
      Map<String, dynamic> levelData = {};
      for (int i = 1; i <= totalLevels; i++) {
        levelData[i.toString()] = 0;
      }
      await prefs.setString(_keyLevelData, jsonEncode(levelData));
    }
  }

  Future<void> saveLevelStars(int level, int stars) async {
    final prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> levelData = await getLevelData();

    levelData[level.toString()] = stars;
    await prefs.setString(_keyLevelData, jsonEncode(levelData));
  }

  Future<int> getLevelStars(int level) async {
    Map<String, dynamic> levelData = await getLevelData();
    return levelData[level.toString()] ?? 0;
  }

  Future<Map<String, dynamic>> getLevelData() async {
    final prefs = await SharedPreferences.getInstance();
    String? data = prefs.getString(_keyLevelData);

    if (data != null) {
      return jsonDecode(data);
    }
    return {};
  }

  Future<bool> isLevelLocked(int level) async {
    if (level == 1) return false;

    int previousLevelStars = await getLevelStars(level - 1);
    return previousLevelStars == 0; // Bị khóa nếu level trước chưa đạt ít nhất 1 sao
  }

  Future<void> resetData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyLevelData);
  }
}
