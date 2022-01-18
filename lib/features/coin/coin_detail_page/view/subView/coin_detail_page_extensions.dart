part of '../coin_detail_page.dart';

extension CoinDetailBlocConsumerView on _CoinDetailPageState {
  Widget get alarmDetails => Column(
        children: [buildAlarmDetailSwitchTile, buildSetAlarmButton],
      );

  Widget get buildAlarmDetailSwitchTile =>
      context.watch<CoinDetailCubit>().isAlarm
          ? Row(
              children: [
                Expanded(
                  child: alarmMinDetail,
                ),
                Expanded(
                  child: alarmMaxDetail,
                ),
              ],
            )
          : Container();

  Widget get alarmMinDetail => Column(
        children: [setAlarmWithMinPriceSwitchTile, minAlarmColumn],
      );
  SwitchListTile get setAlarmWithMinPriceSwitchTile => SwitchListTile(
      title: context.watch<CoinDetailCubit>().isMinAlarmActive == false
          ? Text(
              LocaleKeys.CoinDetailPage_minSwitchTileClose.locale,
              style: context.textTheme.overline,
            )
          : Text(LocaleKeys.CoinDetailPage_minSwitchTileOpen.locale,
              style: context.textTheme.overline),
      value: context.watch<CoinDetailCubit>().isMinAlarmActive,
      onChanged: (value) => context.read<CoinDetailCubit>().changeIsMin());

  Widget get minAlarmColumn =>
      context.watch<CoinDetailCubit>().isMinAlarmActive == false
          ? Container()
          : Column(
              children: [
                minLoopSwitchTile,
                inputRow(LocaleKeys.CoinDetailPage_minTextFormField.locale,
                    context.read<CoinDetailCubit>().minTextEditingController),
                Text("Alarm Voice"),
                buildMinAlarmCard,
              ],
            );

  SwitchListTile get minLoopSwitchTile => SwitchListTile(
      title: context.watch<CoinDetailCubit>().isMinLoop == false
          ? Text(
              "LOOP INACTIVE",
              style: context.textTheme.overline,
            )
          : Text("LOOP ACTIVE", style: context.textTheme.overline),
      value: context.watch<CoinDetailCubit>().isMinLoop,
      onChanged: (value) => context.read<CoinDetailCubit>().changeIsMinLoop());

  Card get buildMinAlarmCard => Card(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text((context.watch<CoinDetailCubit>().minSelectedAudio != null
                ? context.read<CoinDetailCubit>().minSelectedAudio!.name
                : "Alarm 1")),
            IconButton(
                onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const AudioPage()))
                        .then((value) {
                      context.read<CoinDetailCubit>().minSelectedAudio = value;
                    }),
                icon: const Icon(Icons.settings))
          ],
        ),
      );

  Widget get alarmMaxDetail => Column(
        children: [setAlarmWithMaxPriceSwitchTile, maxAlarmColumn],
      );
  SwitchListTile get setAlarmWithMaxPriceSwitchTile => SwitchListTile(
      title: context.watch<CoinDetailCubit>().isMaxAlarmActive == false
          ? Text(
              LocaleKeys.CoinDetailPage_maxSwitchTileClose.locale,
              style: context.textTheme.overline,
            )
          : Text(LocaleKeys.CoinDetailPage_maxSwitchTileOpen.locale,
              style: context.textTheme.overline),
      value: context.watch<CoinDetailCubit>().isMaxAlarmActive,
      onChanged: (value) => context.read<CoinDetailCubit>().changeIsMax());

  Widget get maxAlarmColumn =>
      context.watch<CoinDetailCubit>().isMaxAlarmActive == false
          ? Container()
          : Column(
              children: [
                maxLoopSwitchTile,
                inputRow(LocaleKeys.CoinDetailPage_maxTextFormField.locale,
                    context.read<CoinDetailCubit>().maxTextEditingController),
                Text("Alarm Voice"),
                buildMaxAlarmCard,
              ],
            );
  SwitchListTile get maxLoopSwitchTile => SwitchListTile(
      title: context.watch<CoinDetailCubit>().isMaxLoop == false
          ? Text(
              "LOOP INACTIVE",
              style: context.textTheme.overline,
            )
          : Text("LOOP ACTIVE", style: context.textTheme.overline),
      value: context.watch<CoinDetailCubit>().isMaxLoop,
      onChanged: (value) => context.read<CoinDetailCubit>().changeIsMaxLoop());

  Card get buildMaxAlarmCard => Card(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text((context.watch<CoinDetailCubit>().maxSelectedAudio != null
                ? context.read<CoinDetailCubit>().maxSelectedAudio.name
                : "Alarm 1")),
            IconButton(
                onPressed: () => Navigator.push(
                        /**
                TODO: MAKE İT WİTH PUSH NAMED */
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AudioPage())).then(
                        (value) {
                      context.read<CoinDetailCubit>().maxSelectedAudio = value;
                    }),
                icon: const Icon(Icons.settings))
          ],
        ),
      );

  Widget get buildSetAlarmButton =>
      (context.watch<CoinDetailCubit>().isMinAlarmActive == true ||
              context.watch<CoinDetailCubit>().isMaxAlarmActive == true)
          ? OutlinedButton(
              onPressed: setAlarmOnpressed,
              child: Text(
                LocaleKeys.CoinDetailPage_buttonText.locale,
              ))
          : Container();

  VoidCallback? setAlarmOnpressed() {
    AudioModel? audioModel;
    widget.coin.min =
        context.read<CoinDetailCubit>().minTextEditingController.text.trim() !=
                ""
            ? double.parse(context
                .read<CoinDetailCubit>()
                .minTextEditingController
                .text
                .trim())
            : 0;
    widget.coin.max =
        context.read<CoinDetailCubit>().maxTextEditingController.text.trim() !=
                ""
            ? double.parse(context
                .read<CoinDetailCubit>()
                .maxTextEditingController
                .text
                .trim())
            : 0;
    context.read<CoinDetailCubit>().saveDeleteForAlarm(widget.coin);

    showSnackBar("Alarm Kuruldu :)))))");
  }

  Padding inputRow(String buttonText, TextEditingController controller) {
    return Padding(
      padding: context.paddingLow,
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          label: Text(buttonText),
        ),
      ),
    );
  }
}
