import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import '../constants.dart';
import '../utilities/static_var.dart';

class UserReference {
  // get
  Future<String?> getLanguage() => getLocal(PreferenceKey.language);

  // set
  Future setLanguage(String value) => setLocal(PreferenceKey.language, value);

  Future setLocal(String key, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();
    if (value is int) {
      await prefs.setInt(key, value);
    } else if (value is bool) {
      await prefs.setBool(key, value);
    } else if (value is double) {
      await prefs.setDouble(key, value);
    } else if (value is String) {
      await prefs.setString(key, value);
    } else if (value is List<String>) {
      await prefs.setStringList(key, value);
    }
  }

  Future<T?> getLocal<T>(String key) async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(key)) {
      return prefs.get(key) as T?;
    }
    return null;
  }

}
