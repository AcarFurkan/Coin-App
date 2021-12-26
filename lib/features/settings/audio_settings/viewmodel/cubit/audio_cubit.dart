import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import '../../model/audio_model.dart';
import 'package:just_audio/just_audio.dart';
import 'package:meta/meta.dart';
import 'package:path_provider/path_provider.dart';

part 'audio_state.dart';

class AudioCubit extends Cubit<AudioState> {
  AudioCubit() : super(AudioInitial()) {
    groupValue = audioPaths[0].path;
  }

  List<String> bb = [];

  Future<List<String>> getPath() async {
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;

    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;

    bb.add(tempPath);
    bb.add(appDocPath);
    return bb;
  }

  late String groupValue;

  changeGroupValue(String path) {
    groupValue = path;
    emit(AudioInitial());
  }

  List<AudioModel> audioPaths = [
    AudioModel("War Siren", "assets/audio/war_siren.mp3"),
    AudioModel("Car Alarm ", "assets/audio/car_alarm.mp3"),
    AudioModel("Police Siren ", "assets/audio/police_siren.mp3"),
    AudioModel("Car Alarm Version 2", "assets/audio/police_siren_two.mp3"),
    AudioModel("Car Alarm Version 3", "assets/audio/police_siren_three.mp3"),
    AudioModel("ozcan", "assets/audio/ozcan.mp3"),
    AudioModel("ozcan2", "assets/audio/ozcan2.mp3"),
    AudioModel("lala", "assets/audio/lala.mp3"),
    AudioModel("audio1", "assets/audio/audio_one.mp3"),
    AudioModel("audio2", "assets/audio/audio_two.mp3"),
    AudioModel("audio3", "assets/audio/audio_three.mp3"),
    AudioModel("audio4", "assets/audio/audio_four.mp3"),
  ];

  Future<void> playAudio(int index, AudioPlayer player) async {
    try {
      // await player.setAsset('assets/audio/ozcan2.mp3');

      if (Platform.isWindows) {
        if (player.playing) {
          await player.pause();
          await player.seek(Duration.zero);
        }
        await player.setAsset((audioPaths[index].path));
        player.play();
        player.seek(Duration(seconds: 2));

        // player.seek(Duration(seconds: 1));

      } else {
        await player.setAsset(audioPaths[index].path);
        await player.setClip(
            start: Duration(seconds: 0), end: Duration(seconds: 4));
        await player.setSpeed(2.0);
      }

      //await player.seek(Duration(seconds: 2));
      // player.setLoopMode(LoopMode.one);
      player.play();
    } on PlayerException catch (e) {
      print("Error code: ${e.code}");

      print("Error message: ${e.message}");
    } on PlayerInterruptedException catch (e) {
      print("Connection aborted: ${e.message}");
    } catch (e) {
      print(e);
    }
  }
}
