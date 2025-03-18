import 'package:flower_bloom/theme/app_colors.dart';
import 'package:flutter/material.dart';

class AppTextTheme {
  AppTextTheme._();
  static TextTheme textTheme = const TextTheme(
      // Game Name
      displayLarge: TextStyle(
        fontSize: 32,
        fontFamily: 'Bungee',
        color: AppColors.mainTextColor,
        fontWeight: FontWeight.bold,
      ),
      // Game level text number
      headlineMedium: TextStyle(
        fontSize: 24,
        fontFamily: 'Bungee',
        color: AppColors.mainTextColor,
      ),
      headlineSmall: TextStyle(
        fontSize: 20,
        fontFamily: 'Bungee',
        color: AppColors.mainTextColor,
      ),
      titleLarge: TextStyle(
        fontSize: 18,
        fontFamily: 'Bungee',
        color: AppColors.mainTextColor,
      ),
      // Văn bản chính
      bodyLarge: TextStyle(
        fontSize: 16,
        fontFamily: 'Bungee',
        color: AppColors.mainTextColor,
      ),
      // Văn bản phụ
      bodyMedium: TextStyle(
        fontSize: 14,
        fontFamily: 'Inter',
        fontWeight: FontWeight.w500,
      ),
      labelLarge: TextStyle(
        fontSize: 16,
        fontFamily: 'Fredoka',
        fontWeight: FontWeight.bold,
      ));
}
