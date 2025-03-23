import 'package:flutter/material.dart';
import '../constants.dart';
import '../preference/language_preference.dart';
import '../preference/user_reference.dart';
import '../theme/app_colors.dart';
import '../utilities/audio_manager.dart';
import '../dependencies.dart';

import 'base/base_widget.dart';

class LanguageSettingsDialog extends StatefulWidget {
  final String currentLanguageCode;

  const LanguageSettingsDialog({
    super.key,
    required this.currentLanguageCode,
  });

  @override
  State<LanguageSettingsDialog> createState() => _LanguageSettingsDialogState();
}

class _LanguageSettingsDialogState extends BaseState<LanguageSettingsDialog> {
  late String _selectedLanguageCode;
  final audioManager = injector.get<AudioManager>();
  final userReference = UserReference();

  @override
  void initState() {
    super.initState();
    _selectedLanguageCode = widget.currentLanguageCode;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: SingleChildScrollView(
        child: Container(
          width: 440,
          height: 330,
          padding: const EdgeInsets.all(26),
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(ImagePath.nameBack),
              fit: BoxFit.fill,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 8),
              // Tiêu đề
              Text(
                appLocalizations.languageSettings,
                style: theme.textTheme.headlineMedium?.copyWith(color: Colors.white),
              ),
              const SizedBox(height: 18),

              // Chọn ngôn ngữ
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  appLocalizations.selectLanguage,
                  style: theme.textTheme.bodyLarge,
                ),
              ),
              const SizedBox(height: 12),

              // Tiếng Anh
              _buildLanguageOption('en', appLocalizations.english),

              const SizedBox(height: 8),

              // Tiếng Việt
              _buildLanguageOption('vi', appLocalizations.vietnamese),

              const SizedBox(height: 20),

              // Nút điều khiển
              GestureDetector(
                onTap: () async {
                  audioManager.playSoundEffect(SoundEffect.buttonClick);
                  // Lưu ngôn ngữ vào cả hai nơi để đảm bảo tính nhất quán
                  await LanguagePreference.setLanguageCode(_selectedLanguageCode);
                  await userReference.setLanguage(_selectedLanguageCode);
                  if (context.mounted) {
                    Navigator.of(context).pop(_selectedLanguageCode);
                  }
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.asset(
                      ImagePath.icBtnTheme,
                      height: 40,
                    ),
                    Transform.translate(
                      offset: const Offset(0, -2),
                      child: Text(
                        appLocalizations.apply,
                        style: theme.textTheme.bodyLarge?.copyWith(color: AppColors.iconTextColor),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageOption(String languageCode, String languageName) {
    final isSelected = _selectedLanguageCode == languageCode;

    return GestureDetector(
      onTap: () {
        audioManager.playSoundEffect(SoundEffect.buttonClick);
        setState(() {
          _selectedLanguageCode = languageCode;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white.withOpacity(0.3) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? Colors.white : Colors.white.withOpacity(0.5),
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Text(
              languageName,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
            ),
            const Spacer(),
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: Colors.white,
                size: 24,
              ),
          ],
        ),
      ),
    );
  }
}
