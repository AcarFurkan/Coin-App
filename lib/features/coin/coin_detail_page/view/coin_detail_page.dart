import 'package:auto_size_text/auto_size_text.dart';
import '../../../settings/audio_settings/model/audio_model.dart';
import '../../../settings/audio_settings/view/audio2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:persian_tools/persian_tools.dart';

import '../../../../core/extension/string_extension.dart';
import '../../../../product/language/locale_keys.g.dart';
import '../../../../product/model/my_coin_model.dart';
import '../viewmodel/cubit/cubit/coin_detail_cubit.dart';

part './subView/coin_detail_page_extensions.dart';

class CoinDetailPage extends StatefulWidget {
  final MainCurrencyModel coin;
  const CoinDetailPage({Key? key, required this.coin}) : super(key: key);

  @override
  State<CoinDetailPage> createState() => _CoinDetailPageState();
}

class _CoinDetailPageState extends State<CoinDetailPage> {
  late final TextEditingController _minTextEditingController;
  late final TextEditingController _maxTextEditingController;
  @override
  void initState() {
    super.initState();
    context.read<CoinDetailCubit>().getCoinByNameFromDb(widget.coin.id);
    context.read<CoinDetailCubit>().setInComingCoin(widget.coin);

    _minTextEditingController = TextEditingController();
    _maxTextEditingController = TextEditingController();
    if (context.read<CoinDetailCubit>().myCoin != null) {
      _minTextEditingController.text =
          context.read<CoinDetailCubit>().myCoin!.min.toString();
      _maxTextEditingController.text =
          context.read<CoinDetailCubit>().myCoin!.max.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return _blocConsumer();
  }

  BlocConsumer<BlocBase<Object?>, Object?> _blocConsumer() {
    return BlocConsumer<CoinDetailCubit, CoinDetailState>(
        builder: (context, state) {
          return Hero(
            tag: widget.coin.id,
            child: Scaffold(
              appBar: buildAppBar(context),
              body: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    //LineChartSample2(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        currencyPriceCardItem(context, "High of 24 hour: ",
                            widget.coin.highOf24h ?? ""),
                        currencyPriceCardItem(context, "Low of 24 hour: ",
                            widget.coin.lowOf24h ?? ""),
                      ],
                    ),

                    alarmCoin(),
                    alarmDetails()
                  ],
                ),
              ),
            ),
          );
        },
        listener: (context, state) {});
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(widget.coin.name.toUpperCase()),
      actions: [
        favoriteButton(
            context,
            const Icon(
              Icons.favorite,
              color: Colors.red,
            ),
            const Icon(
              Icons.favorite_border,
              color: Colors.red,
            )),
        favoriteButton(
          context,
          Icon(
            Icons.star_rounded,
            color: Colors.yellow[600],
          ),
          Icon(
            Icons.star_border_rounded,
            color: Colors.yellow[600],
          ),
        ),
      ],
    );
  }

  IconButton favoriteButton(
      BuildContext context, Widget firstWidget, Widget secodnWidget) {
    return IconButton(
        onPressed: () {
          context.read<CoinDetailCubit>().coinFavoriteActionUI(widget.coin);
          context.read<CoinDetailCubit>().isFavorite == true
              ? showSnackBar("Favorilere eklendi :)))))")
              : showSnackBar("Favorilerden kaldırıldı :)))))");
        },
        icon: context.watch<CoinDetailCubit>().isFavorite == true
            ? firstWidget
            : secodnWidget);
  }

  showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(milliseconds: 500),
      ),
    );
  }

  Card currencyPriceCardItem(BuildContext context, String title, String price) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.headline6,
            ),
            AutoSizeText(
              price.addComma,
              style: TextStyle(color: Theme.of(context).tabBarTheme.labelColor),
              //style: Theme.of(context).textTheme.headline6,
            ),
          ],
        ),
      ),
    );
  }

  Widget alarmCoin() {
    return SwitchListTile(
        title: context.watch<CoinDetailCubit>().isAlarm == false
            ? Text(LocaleKeys.CoinDetailPage_setAlarmClose.locale)
            : Text(LocaleKeys.CoinDetailPage_setAlarmOpen.locale),
        value: context.watch<CoinDetailCubit>().isAlarm,
        onChanged: (value) {
          context.read<CoinDetailCubit>().coinAlarmActionUI(widget.coin);
        });
  }

  Widget alarmDetails() {
    return Column(
      children: [buildAlarmDetailSwitchTile(), buildSetAlarmButton()],
    );
  }

  Widget buildAlarmDetailSwitchTile() {
    return context.watch<CoinDetailCubit>().isAlarm
        ? Row(
            children: [
              Expanded(
                child: alarmMinDetail(),
              ),
              Expanded(
                child: alarmMaxDetail(),
              ),
            ],
          )
        : Text("");
  }

  Widget buildSetAlarmButton() {
    return (context.watch<CoinDetailCubit>().isMinAlarmActive == true ||
            context.watch<CoinDetailCubit>().isMaxAlarmActive == true)
        ? OutlinedButton(
            onPressed: setAlarmOnpressed,
            child: Text(
              LocaleKeys.CoinDetailPage_buttonText.locale,
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
            ))
        : Text("");
  }

  Widget alarmMinDetail() {
    return Column(
      children: [setAlarmWithMinPriceSwitchTile(), minAlarmColumn()],
    );
  }

  Widget minAlarmColumn() {
    return context.watch<CoinDetailCubit>().isMinAlarmActive == false
        ? const Text("")
        : Column(
            children: [
              minLoopSwitchTile(),
              inputRow(LocaleKeys.CoinDetailPage_minTextFormField.locale,
                  _minTextEditingController),
              Text("Alarm Voice"),
              buildMinAlarmCard(),
            ],
          );
  }

  Card buildMinAlarmCard() {
    return Card(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text((context.watch<CoinDetailCubit>().minSelectedAudio != null
              ? context.read<CoinDetailCubit>().minSelectedAudio!.name
              : "Alarm 1")),
          IconButton(
              onPressed: () {
                Navigator.push(context,
                        MaterialPageRoute(builder: (context) => AudioPage()))
                    .then((value) {
                  context.read<CoinDetailCubit>().minSelectedAudio = value;
                });
              },
              icon: Icon(Icons.settings))
        ],
      ),
    );
  }

  SwitchListTile minLoopSwitchTile() {
    return SwitchListTile(
        title: context.watch<CoinDetailCubit>().isMinLoop == false
            ? Text(
                "LOOP INACTIVE",
                style: TextStyle(fontSize: 10),
              )
            : Text("LOOP ACTIVE", style: TextStyle(fontSize: 10)),
        value: context.watch<CoinDetailCubit>().isMinLoop,
        onChanged: (value) {
          context.read<CoinDetailCubit>().changeIsMinLoop();
        });
  }

  SwitchListTile setAlarmWithMinPriceSwitchTile() {
    return SwitchListTile(
        title: context.watch<CoinDetailCubit>().isMinAlarmActive == false
            ? Text(
                LocaleKeys.CoinDetailPage_minSwitchTileClose.locale,
                style: TextStyle(fontSize: 10),
              )
            : Text(LocaleKeys.CoinDetailPage_minSwitchTileOpen.locale,
                style: TextStyle(fontSize: 10)),
        value: context.watch<CoinDetailCubit>().isMinAlarmActive,
        onChanged: (value) {
          context.read<CoinDetailCubit>().changeIsMin();
        });
  }

  Widget alarmMaxDetail() {
    return Column(
      children: [
        SwitchListTile(
            title: context.watch<CoinDetailCubit>().isMaxAlarmActive == false
                ? Text(
                    LocaleKeys.CoinDetailPage_maxSwitchTileClose.locale,
                    style: const TextStyle(fontSize: 10),
                  )
                : Text(LocaleKeys.CoinDetailPage_maxSwitchTileOpen.locale,
                    style: const TextStyle(fontSize: 10)),
            value: context.watch<CoinDetailCubit>().isMaxAlarmActive,
            onChanged: (value) {
              context.read<CoinDetailCubit>().changeIsMax();
            }),
        context.watch<CoinDetailCubit>().isMaxAlarmActive == false
            ? const Text("")
            : Column(
                children: [
                  SwitchListTile(
                      title: context.watch<CoinDetailCubit>().isMaxLoop == false
                          ? Text(
                              "LOOP INACTIVE",
                              style: TextStyle(fontSize: 10),
                            )
                          : Text("LOOP ACTIVE", style: TextStyle(fontSize: 10)),
                      value: context.watch<CoinDetailCubit>().isMaxLoop,
                      onChanged: (value) {
                        context.read<CoinDetailCubit>().changeIsMaxLoop();
                      }),
                  inputRow(LocaleKeys.CoinDetailPage_maxTextFormField.locale,
                      _maxTextEditingController),
                  Text("Alarm Voice"),
                  Card(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text((context
                                    .watch<CoinDetailCubit>()
                                    .maxSelectedAudio !=
                                null
                            ? context
                                .read<CoinDetailCubit>()
                                .maxSelectedAudio
                                .name
                            : "Alarm 1")),
                        IconButton(
                            onPressed: () {
                              Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => AudioPage()))
                                  .then((value) {
                                context
                                    .read<CoinDetailCubit>()
                                    .maxSelectedAudio = value;
                              });
                            },
                            icon: Icon(Icons.settings))
                      ],
                    ),
                  ),
                ],
              ),
      ],
    );
  }

  VoidCallback? setAlarmOnpressed() {
    AudioModel? audioModel;
    widget.coin.min = _minTextEditingController.text.trim() != ""
        ? double.parse(_minTextEditingController.text.trim())
        : 0;
    widget.coin.max = _maxTextEditingController.text.trim() != ""
        ? double.parse(_maxTextEditingController.text.trim())
        : 0;
    context.read<CoinDetailCubit>().saveDeleteForAlarm(widget.coin);

    showSnackBar("Alarm Kuruldu :)))))");
  }

  Padding inputRow(String buttonText, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
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
