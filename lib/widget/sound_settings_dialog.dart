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
    setState(() {
      if (_backgroundVolume > 0) {
        // Nếu đang có âm nhạc, tắt đi
        _backgroundVolume = 0;
        audioManager.setBackgroundVolume(0);
        audioManager.pauseBackgroundMusic();
      } else {
        // Nếu đang tắt, bật lại 100%
        _backgroundVolume = 1.0;
        audioManager.setBackgroundVolume(1.0);
        audioManager.playBackgroundMusic();
      }
    });
  }

  void _handleSoundIconTap() {
    setState(() {
      if (_effectVolume > 0) {
        // Nếu đang có âm thanh, tắt đi
        _effectVolume = 0;
        audioManager.setEffectVolume(0);
      } else {
        // Nếu đang tắt, bật lại 100%
        _effectVolume = 1.0;
        audioManager.setEffectVolume(1.0);
      }
    });
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
                'Cài đặt âm thanh',
                style: theme.textTheme.headlineMedium?.copyWith(color: Colors.white),
              ),
              const SizedBox(height: 18),

              // Thanh trượt âm nhạc nền
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Âm nhạc nền',
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
                  'Âm thanh hiệu ứng',
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
                        'Đóng',
                        style: theme.textTheme.bodyLarge?.copyWith(color: AppColors.iconTextColor),
                      ),
                    ),
                  ],
                ),
              ),
              // ElevatedButton(
              //   onPressed: () {
              //     audioManager.playSoundEffect(SoundEffect.buttonClick);
              //     Navigator.of(context).pop();
              //   },
              //   style: ElevatedButton.styleFrom(
              //     backgroundColor: Theme.of(context).primaryColor,
              //     padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
              //     shape: RoundedRectangleBorder(
              //       borderRadius: BorderRadius.circular(8),
              //     ),
              //   ),
              //   child: Text(
              //     'Đóng',
              //     style: Theme.of(context).textTheme.titleMedium?.copyWith(
              //       color: Colors.white,
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
