/*
import 'dart:io';

import 'package:audio_manager/audio_manager.dart' as audioManager;
import 'package:coin_with_architecture/features/settings/audio_settings/model/audio_model.dart';
import 'package:coin_with_architecture/features/settings/audio_settings/viewmodel/cubit/audio_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:libwinmedia/libwinmedia.dart';
import 'package:path_provider/path_provider.dart';

class AudioPage extends StatefulWidget {
  const AudioPage({Key? key}) : super(key: key);

  @override
  State<AudioPage> createState() => _AudioPageState();
}

class _AudioPageState extends State<AudioPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Alarmını seç"),
      ),
      body: BlocConsumer<AudioCubit, AudioState>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          return Scaffold(
            body: Column(
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: context.read<AudioCubit>().audioPaths.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      title: Text(
                          context.read<AudioCubit>().audioPaths[index].name),
                      trailing: Radio<String>(
                        value:
                            context.read<AudioCubit>().audioPaths[index].path,
                        groupValue: context.watch<AudioCubit>().groupValue,
                        onChanged: (onChanged) {
                          trial(onChanged!, index);
                          // playMusicDesktop( context.read<AudioCubit>().audioPaths[index]);
                        },
                      ),
                    );
                  },
                ),
                Platform.isWindows
                    ? FutureBuilder<List<String>>(
                        future: aa(),
                        builder:
                            (context, AsyncSnapshot<List<String>> snapshot) {
                          return Column(
                            children: [
                              Text((snapshot.data ?? ["aa"])[0]),
                              Text((snapshot.data ?? ["aa", "bb"])[1])
                            ],
                          );
                        })
                    : Text("this is android")
                /* Column(
                  children: [
                    Text(context.read<AudioCubit>().bb[0]),
                    Text(context.read<AudioCubit>().bb[1])
                  ],
                )*/
              ],
            ),
          );
        },
      ),
    );
  }

  Widget trial(String onChanged, int index) {
    if (Platform.isAndroid) {
      context.read<AudioCubit>().changeGroupValue(onChanged);
      playMusicFromPhone(context.read<AudioCubit>().audioPaths[index]);
      return Text("this is android");
    } else if (Platform.isWindows) {
      return FutureBuilder<List<String>>(
          future: aa(),
          builder: (context, AsyncSnapshot<List<String>> snapshot) {
            return Column(
              children: [
                Text((snapshot.data ?? ["aa"])[0]),
                Text((snapshot.data ?? ["aa", "bb"])[1])
              ],
            );
          });
    } else {
      return Text("this is different platform");
    }
  }

  Future<List<String>> aa() async {
    List<String> bb = [];
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;

    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;

    bb.add(tempPath);
    bb.add(appDocPath);
    return bb;
  }

  Future<void> playMusicDesktop(AudioModel model) async {
    await getTemporaryDirectory();
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;

    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;
    print(tempPath);
    print(appDocPath);
    var player = Player(id: 0);
    player.streams.medias.listen((List<Media> medias) {});
    player.streams.isPlaying.listen((bool isPlaying) {});
    player.streams.isBuffering.listen((bool isBuffering) {});
    player.streams.isCompleted.listen((bool isCompleted) {});
    player.streams.position.listen((Duration position) {});
    player.streams.duration.listen((Duration duration) {});
    player.streams.index.listen((int index) {});
    player.open([
      // Media( uri: 'assets/ozcan.mp3', ),

      Media(uri: 'file://C:/ozcan.mp3'),
    ]);
    player.play();
    player.seek(Duration(seconds: 20));
  }

  void playMusicFromPhone(AudioModel model) {
    audioManager.AudioManager.instance
        .start(
            model.path,
            // "network format resource"
            // "local resource (file://${file.path})"
            "SAATTTTTTTTT",
            desc: "SAAAAAAATTTT",
            // cover: "network cover image resource"
            cover: model.path)
        .then((err) {
      //print(err);
    });
  }
}
*/