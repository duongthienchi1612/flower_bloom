import 'package:shared_preferences/shared_preferences.dart';
import '../constants.dart';

class UserReference {
  // get
  Future<String?> getLanguage() => getLocal(PreferenceKey.language);
  Future<bool?> getIsFirstTime() => getLocal(PreferenceKey.isFirstTime);

  // set
  Future setLanguage(String value) => setLocal(PreferenceKey.language, value);
  Future setIsFirstTime(bool value) => setLocal(PreferenceKey.isFirstTime, value);

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
