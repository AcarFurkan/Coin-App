import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:persian_tools/persian_tools.dart';

import '../../../../core/extension/context_extension.dart';
import '../../../../core/extension/string_extension.dart';
import '../../../../product/language/locale_keys.g.dart';
import '../../../../product/model/my_coin_model.dart';
import '../../../settings/subpage/audio_settings/model/audio_model.dart';
import '../../../settings/subpage/audio_settings/view/audio2.dart';
import '../viewmodel/cubit/cubit/coin_detail_cubit.dart';

part './subView/coin_detail_page_extensions.dart';

class CoinDetailPage extends StatefulWidget {
  final MainCurrencyModel coin;
  const CoinDetailPage({Key? key, required this.coin}) : super(key: key);

  @override
  State<CoinDetailPage> createState() => _CoinDetailPageState();
}

class _CoinDetailPageState extends State<CoinDetailPage> {
  @override
  void initState() {
    super.initState();
    context.read<CoinDetailCubit>().getCoinByNameFromDb(widget.coin.id);
    context.read<CoinDetailCubit>().setInComingCoin(widget.coin);

    if (context.read<CoinDetailCubit>().myCoin != null) {
      context.read<CoinDetailCubit>().minTextEditingController.text =
          context.read<CoinDetailCubit>().myCoin!.min.toString();
      context.read<CoinDetailCubit>().maxTextEditingController.text =
          context.read<CoinDetailCubit>().myCoin!.max.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return _blocConsumer;
  }

  BlocConsumer<BlocBase<Object?>, Object?> get _blocConsumer =>
      BlocConsumer<CoinDetailCubit, CoinDetailState>(
          builder: (context, state) {
            return Hero(
              tag: widget.coin.id,
              child: Scaffold(
                appBar: buildAppBar(context),
                body: buildScaffoldBody(context),
              ),
            );
          },
          listener: (context, state) {});

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(widget.coin.name.toUpperCase()),
      actions: [
        favoriteButton(
            context,
            Icon(
              Icons.favorite,
              color: context.colors.error,
            ),
            Icon(Icons.favorite_border, color: context.colors.error)),
        favoriteButton(
          context,
          Icon(
            Icons.star_rounded,
            color: context.theme.accentColor,
          ),
          Icon(
            Icons.star_border_rounded,
            color: context.theme.accentColor,
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

  Center buildScaffoldBody(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // LineChartSample2(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              currencyPriceCardItem(
                  context, "High of 24 hour: ", widget.coin.highOf24h ?? ""),
              currencyPriceCardItem(
                  context, "Low of 24 hour: ", widget.coin.lowOf24h ?? ""),
            ],
          ),
          alarmCoin,
          alarmDetails
        ],
      ),
    );
  }

  showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: context.lowDuration,
      ),
    );
  }

  Card currencyPriceCardItem(BuildContext context, String title, String price) {
    return Card(
      child: Padding(
        padding: context.paddingLow,
        child: Column(
          children: [
            Text(
              title,
              style: context.textTheme.headline6,
            ),
            AutoSizeText(
              price.addComma,
              style: context.textTheme.subtitle1,
              //style: Theme.of(context).textTheme.headline6,
            ),
          ],
        ),
      ),
    );
  }

  Widget get alarmCoin => SwitchListTile(
      title: context.watch<CoinDetailCubit>().isAlarm == false
          ? Text(LocaleKeys.CoinDetailPage_setAlarmClose.locale)
          : Text(LocaleKeys.CoinDetailPage_setAlarmOpen.locale),
      value: context.watch<CoinDetailCubit>().isAlarm,
      onChanged: (value) =>
          context.read<CoinDetailCubit>().coinAlarmActionUI(widget.coin));
}
