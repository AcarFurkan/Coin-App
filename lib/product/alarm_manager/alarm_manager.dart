import 'dart:async';

import '../../features/settings/subpage/audio_settings/model/audio_model.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';

class AudioManager {
  static AudioManager? _instance;

  static AudioManager get instance {
    _instance ??= AudioManager._init();
    return _instance!;
  }

  late AudioPlayer _player;

  AudioManager._init() {
    _player = AudioPlayer();
  }

  Future<void> play(AudioModel model,
      {bool isLoop = false, int time = 2, required String title}) async {
    if (model.name == "vibration") {
      _player.setVolume(0);
    } else {
      _player.setVolume(1);
    }
    _player.setAudioSource(AudioSource.uri(
      Uri.parse("asset:///${model.path}"),
      tag: MediaItem(
        id: 'asset:///${model.path}',
        album: model.name,
        title: title,
        artUri: Uri.file("assets/bg.jpeg"),
      ),
    ));

    if (isLoop) {
      _player.setLoopMode(LoopMode.one);
    } else {
      print(time);
      Timer(Duration(seconds: time), () {
        if (AudioManager.instance.isPlaying) {
          _player.stop();
        }
      });
    }
    await _player.play();
  }

  Future<void> stop() async {
    await _player.stop();
  }

  bool get isPlaying => _player.playing;
}
