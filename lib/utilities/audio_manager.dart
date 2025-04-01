import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import '../constants.dart';
import 'dart:async';

class AudioManager {
  final AudioPlayer _backgroundPlayer = AudioPlayer();
  final AudioPlayer _effectPlayer = AudioPlayer();
  final AudioPlayer _levelAppearPlayer = AudioPlayer();
  final bool _isSoundOn = true;
  final bool _isSoundOnBackground = true;
  double _backgroundVolume = 0.3;
  double _effectVolume = 1.0;
  
  // Kiểm tra nếu đang chạy trên nền tảng web
  final bool _isWeb = kIsWeb;

  AudioManager() {
    _init();
  }

  Future<void> _init() async {
    await _backgroundPlayer.setAsset(BackgroundMusic.main);
    _backgroundPlayer.setLoopMode(LoopMode.one);
    _backgroundPlayer.setVolume(_backgroundVolume);
    _effectPlayer.setVolume(_effectVolume);
    _levelAppearPlayer.setVolume(_effectVolume);

    // Đối với web, chỉ phát nhạc nền sau khi người dùng tương tác
    if (!_isWeb) {
      playBackgroundMusic();
    }
  }

  Future<void> playBackgroundMusic() async {
    if (_isSoundOnBackground) {
      try {
        await _backgroundPlayer.play();
      } catch (e) {
        if (kDebugMode) {
          print('Error playing background music: $e');
        }
      }
    }
  }

  void pauseBackgroundMusic() {
    _backgroundPlayer.pause();
  }

  void stopBackgroundMusic() {
    _backgroundPlayer.stop();
  }

  void playSoundEffect(String assetPath) {
    if (_isSoundOn) {
      if (assetPath == SoundEffect.levelAppear) {
        _playLevelAppearSound(assetPath);
      } else {
        _playRegularSoundEffect(assetPath);
      }

      // Trên nền tảng web, đảm bảo nhạc nền bắt đầu sau lần tương tác đầu tiên
      if (_isWeb && !_backgroundPlayer.playing) {
        playBackgroundMusic();
      }
    }
  }

  void _playRegularSoundEffect(String assetPath) async {
    try {
      await _effectPlayer.setAsset(assetPath);
      _effectPlayer.play();
    } catch (e) {
      if (kDebugMode) {
        print('Error playing sound effect: $e');
      }
    }
  }

  void _playLevelAppearSound(String assetPath) async {
    try {
      await _levelAppearPlayer.setAsset(assetPath);
      _levelAppearPlayer.play();
    } catch (e) {
      if (kDebugMode) {
        print('Error playing level appear sound: $e');
      }
    }
  }

  bool get isSoundOn => _isSoundOn;

  void setBackgroundVolume(double volume) {
    _backgroundVolume = volume;
    _backgroundPlayer.setVolume(volume);
  }

  void setEffectVolume(double volume) async {
    _effectVolume = volume;
    await _effectPlayer.setVolume(volume);
    await _levelAppearPlayer.setVolume(volume);
  }

  double get backgroundVolume => _backgroundVolume;
  double get effectVolume => _effectVolume;

  void dispose() {
    _backgroundPlayer.dispose();
    _effectPlayer.dispose();
    _levelAppearPlayer.dispose();
  }
}
