import 'package:audioplayers/audioplayers.dart';

class SoundFX {
  static final AudioPlayer _player = AudioPlayer();

  static Future<void> playAchievement() async {
    await _player.play(AssetSource('audio/achievement.mp3'), volume: 1.0);
  }

  static Future<void> playQuestComplete() async {
    await _player.play(AssetSource('audio/quest_complete.mp3'), volume: 1.0);
  }
}
