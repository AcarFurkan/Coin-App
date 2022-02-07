import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';

import '../../../../../../core/extension/context_extension.dart';
import '../../../../../../core/extension/string_extension.dart';
import '../../../../../../product/alarm_manager/alarm_manager.dart';
import '../../../../../../product/language/locale_keys.g.dart';
import '../../model/audio_model.dart';

part 'audio_state.dart';

class AudioCubit extends Cubit<AudioState> {
  AudioCubit() : super(AudioInitial()) {
    groupValue = audioPaths[0].path;
  }

  late String groupValue;

  changeGroupValue(String path) {
    groupValue = path;
    emit(AudioInitial());
  }

  List<AudioModel> audioPaths = [
    AudioModel("vibration", "assets/audio/vibration.mp3"),
    AudioModel(LocaleKeys.alarmNames_sweetAlarm.locale,
        "assets/audio/sweet_alarm.mp3"),
    AudioModel(
        LocaleKeys.alarmNames_warSiren.locale, "assets/audio/war_siren.mp3"),
    AudioModel(
        LocaleKeys.alarmNames_carAlarm.locale, "assets/audio/car_alarm.mp3"),
    AudioModel(LocaleKeys.alarmNames_policeSiren.locale,
        "assets/audio/police_siren.mp3"),
    AudioModel(LocaleKeys.alarmNames_carAlarmTwo.locale,
        "assets/audio/police_siren_two.mp3"),
    AudioModel(LocaleKeys.alarmNames_carAlarmThree.locale,
        "assets/audio/police_siren_three.mp3"),
    AudioModel(LocaleKeys.alarmNames_annoyingAlarm.locale,
        "assets/audio/audio_one.mp3"),
    AudioModel(LocaleKeys.alarmNames_annoyingAlarmTwo.locale,
        "assets/audio/audio_two.mp3"),
    AudioModel(LocaleKeys.alarmNames_annoyingAlarmThree.locale,
        "assets/audio/audio_three.mp3"),
    AudioModel(LocaleKeys.alarmNames_annoyingAlarmFour.locale,
        "assets/audio/audio_four.mp3"),
  ];

  Future<void> playAudio(int index, BuildContext context, String title) async {
    AudioManager.instance.play(audioPaths[index],
        time: context.ultraHighDuration.inSeconds, title: title);
  }
}


/**
 * Future<void> playAudio(
      int index, AudioPlayer player, BuildContext context) async {
    try {
      // await player.setAsset('assets/audio/ozcan2.mp3');

      if (Platform.isWindows) {
        if (player.playing) {
          await player.pause();
          await player.seek(Duration.zero);
        }
        await player.setAsset((audioPaths[index].path));
        player.play();
        player.seek(context.midDuration);
        // player.seek(Duration(seconds: 1));

      } else {
        await player.setAsset(audioPaths[index].path);
        await player.setClip(
            start: const Duration(seconds: 0), end: Duration(seconds: 4));
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
 */
