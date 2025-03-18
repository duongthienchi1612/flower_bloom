import 'package:just_audio/just_audio.dart';
import '../constants.dart';

class AudioManager {
  final AudioPlayer _backgroundPlayer = AudioPlayer();
  final AudioPlayer _effectPlayer = AudioPlayer();
  final bool _isSoundOn = true;
  final bool _isSoundOnBackground = true;
  double _backgroundVolume = 0.3;
  double _effectVolume = 1.0;

  AudioManager() {
    _init();
  }

  void _init() {
    _backgroundPlayer.setAsset(BackgroundMusic.main);
    _backgroundPlayer.setLoopMode(LoopMode.one);
    _backgroundPlayer.setVolume(_backgroundVolume);
    _effectPlayer.setVolume(_effectVolume);

    playBackgroundMusic();
  }

  void playBackgroundMusic() {
    if (_isSoundOnBackground) {
      _backgroundPlayer.play();
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
      _effectPlayer.setAsset(assetPath);
      _effectPlayer.play();
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
  }

  double get backgroundVolume => _backgroundVolume;
  double get effectVolume => _effectVolume;

  void dispose() {
    _backgroundPlayer.dispose();
    _effectPlayer.dispose();
  }
}
