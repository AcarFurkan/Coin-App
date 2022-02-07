import '../../../../../core/extension/string_extension.dart';
import '../../../../../product/alarm_manager/alarm_manager.dart';
import '../../../../../product/language/locale_keys.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../viewmodel/cubit/audio_cubit.dart';

class AudioPage extends StatefulWidget {
  const AudioPage({Key? key}) : super(key: key);

  @override
  State<AudioPage> createState() => _AudioPageState();
}

class _AudioPageState extends State<AudioPage> {
  ///late AudioPlayer player;
  late int selectedIndex;
  @override
  void initState() {
    super.initState();
    selectedIndex = 0;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                AudioManager.instance.stop();
                //final _audioHandler = locator<AudioHandler>();
                //_audioHandler.stop();
                //_audioHandler.removeQueueItemAt(0);
              },
              icon: const Icon(Icons.music_off))
        ],
        title: Text(LocaleKeys.alarmPage_appBarTitle.locale),
        leading: IconButton(
            onPressed: () {
              AudioManager.instance.stop();

              Navigator.pop(context,
                  context.read<AudioCubit>().audioPaths[selectedIndex]);
            },
            icon: const Icon(Icons.arrow_back_ios)),
      ),
      body: BlocConsumer<AudioCubit, AudioState>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
            body: buildListViewBuilder(context),
          );
        },
      ),
    );
  }

  ListView buildListViewBuilder(BuildContext context) {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      shrinkWrap: true,
      itemCount: context.read<AudioCubit>().audioPaths.length,
      itemBuilder: (BuildContext context, int index) {
        return buildRadioListTile(context, index);
      },
    );
  }

  RadioListTile<String> buildRadioListTile(BuildContext context, int index) {
    return RadioListTile<String>(
      title: Text(context.read<AudioCubit>().audioPaths[index].name),
      value: context.read<AudioCubit>().audioPaths[index].path,
      groupValue: context.watch<AudioCubit>().groupValue,
      onChanged: (onChanged) async {
        selectedIndex = index;
        context.read<AudioCubit>().changeGroupValue(onChanged!);
        await context.read<AudioCubit>().playAudio(index, context, "Trial");
      },
    );
  }
}
