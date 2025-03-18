import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'user_reference.dart';

class LanguagePreference {
  static const String _languageCodeKey = 'language_code';

  // Lưu mã ngôn ngữ vào SharedPreferences
  static Future<void> setLanguageCode(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageCodeKey, languageCode);

    // Đồng bộ với UserReference
    final userReference = UserReference();
    await userReference.setLanguage(languageCode);
  }

  // Lấy mã ngôn ngữ từ SharedPreferences
  static Future<String?> getLanguageCode() async {
    final prefs = await SharedPreferences.getInstance();
    String? languageCode = prefs.getString(_languageCodeKey);

    // Nếu không có trong LanguagePreference, thử lấy từ UserReference
    if (languageCode == null) {
      final userReference = UserReference();
      languageCode = await userReference.getLanguage();

      // Nếu có trong UserReference, lưu lại vào LanguagePreference
      if (languageCode != null) {
        await prefs.setString(_languageCodeKey, languageCode);
      }
    }

    return languageCode;
  }

  // Lấy Locale dựa trên mã ngôn ngữ đã lưu
  static Future<Locale?> getLocale() async {
    final languageCode = await getLanguageCode();
    if (languageCode == null) {
      return null; // Sử dụng ngôn ngữ mặc định của hệ thống
    }
    return Locale(languageCode);
  }
}
