import 'package:audioplayers/audioplayers.dart';
import 'package:flower_bloom/constants.dart';

class AudioManager {
  // Player cho nhạc nền
  late AudioPlayer _bgmPlayer;

  // Trạng thái bật/tắt âm thanh
  bool isSoundOn = true;

  Future<void> init() async {
    _bgmPlayer = AudioPlayer();
    await _bgmPlayer.setReleaseMode(ReleaseMode.loop);
  }

  Future<void> playBackgroundMusic() async {
    if (isSoundOn) {
      await _bgmPlayer.play(AssetSource(SoundEffect.background));
    }
  }

  Future<void> stopBackgroundMusic() async {
    await _bgmPlayer.stop();
  }

  Future<void> toggleSound() async {
    isSoundOn = !isSoundOn;
    if (isSoundOn) {
      await playBackgroundMusic();
    } else {
      await stopBackgroundMusic();
    }
  }

  Future<void> playSoundEffect(String assetPath) async {
    if (isSoundOn) {
      final player = AudioPlayer();
      await player.play(AssetSource(assetPath));
    }
  }

}
