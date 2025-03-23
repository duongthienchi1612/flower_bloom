import 'package:flower_bloom/theme/app_colors.dart';
import 'package:flutter/material.dart';
import '../constants.dart';
import '../utilities/audio_manager.dart';
import '../dependencies.dart';
import '../widget/base/base_widget.dart';

class SoundSettingsDialog extends StatefulWidget {
  final double backgroundVolume;
  final double effectVolume;

  const SoundSettingsDialog({
    super.key,
    required this.backgroundVolume,
    required this.effectVolume,
  });

  @override
  State<SoundSettingsDialog> createState() => _SoundSettingsDialogState();
}

class _SoundSettingsDialogState extends BaseState<SoundSettingsDialog> {
  late double _backgroundVolume;
  late double _effectVolume;
  final audioManager = injector.get<AudioManager>();

  @override
  void initState() {
    super.initState();
    _backgroundVolume = widget.backgroundVolume;
    _effectVolume = widget.effectVolume;
  }

  void _handleBackgroundMusicIconTap() {
    // Lưu giá trị hiện tại
    final newVolume = _backgroundVolume > 0 ? 0.0 : 1.0;

    // Cập nhật UI
    setState(() {
      _backgroundVolume = newVolume;
    });

    // Thực hiện các thao tác không liên quan đến UI sau khi setState
    if (newVolume > 0) {
      audioManager.setBackgroundVolume(newVolume);
      audioManager.playBackgroundMusic();
    } else {
      audioManager.setBackgroundVolume(newVolume);
      audioManager.pauseBackgroundMusic();
    }
  }

  void _handleSoundIconTap() {
    // Lưu giá trị hiện tại
    final newVolume = _effectVolume > 0 ? 0.0 : 1.0;

    // Cập nhật UI
    setState(() {
      _effectVolume = newVolume;
    });

    // Thực hiện các thao tác không liên quan đến UI sau khi setState
    audioManager.setEffectVolume(newVolume);
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
                appLocalizations.soundSettings,
                style: theme.textTheme.headlineMedium?.copyWith(color: Colors.white),
              ),
              const SizedBox(height: 18),

              // Thanh trượt âm nhạc nền
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  appLocalizations.backgroundMusic,
                  style: theme.textTheme.bodyLarge,
                ),
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: _handleBackgroundMusicIconTap,
                    child: Image.asset(
                      _backgroundVolume > 0 ? ImagePath.icSoundOn : ImagePath.icSoundOff,
                      width: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Slider(
                          value: _backgroundVolume,
                          onChanged: (value) {
                            setState(() {
                              _backgroundVolume = value;
                            });
                            audioManager.setBackgroundVolume(value);
                            // Nếu âm lượng > 0 thì phát nhạc, nếu = 0 thì tạm dừng
                            if (value > 0) {
                              audioManager.playBackgroundMusic();
                            } else {
                              audioManager.pauseBackgroundMusic();
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Thanh trượt âm thanh hiệu ứng
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  appLocalizations.soundEffects,
                  style: theme.textTheme.bodyLarge,
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: _handleSoundIconTap,
                    child: Image.asset(
                      _effectVolume > 0 ? ImagePath.icSoundOn : ImagePath.icSoundOff,
                      width: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Slider(
                          value: _effectVolume,
                          onChanged: (value) {
                            setState(() {
                              _effectVolume = value;
                            });
                            audioManager.setEffectVolume(value);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Nút đóng
              GestureDetector(
                onTap: () {
                  audioManager.playSoundEffect(SoundEffect.buttonClick);
                  Navigator.of(context).pop();
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
                        appLocalizations.close,
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
}
