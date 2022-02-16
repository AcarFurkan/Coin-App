import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/extension/context_extension.dart';
import '../../../../core/extension/string_extension.dart';
import '../../../../product/language/locale_keys.g.dart';
import '../../../../product/model/coin/my_coin_model.dart';
import '../../../home/viewmodel/home_viewmodel.dart';
import '../../../settings/subpage/audio_settings/view/audio_page.dart';
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
      centerTitle: true,
      title: Text(widget.coin.name.toUpperCase()),
      actions: [
        favoriteButton(
          context,
          Icon(
            Icons.star_rounded,
            color: Colors.orange,
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
              ? showSnackBar(LocaleKeys.CoinDetailPage_addedFavorites.locale)
              : showSnackBar(
                  LocaleKeys.CoinDetailPage_deletedFromFavorites.locale);
        },
        icon: context.watch<CoinDetailCubit>().isFavorite == true
            ? firstWidget
            : secodnWidget);
  }

  Center buildScaffoldBody(BuildContext context) {
    return Center(
      child: ListView(
        padding: context.paddingLow,
        physics: const BouncingScrollPhysics(),
        children: [
          // LineChartSample2(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: currencyPriceCardItem(
                    context,
                    LocaleKeys.CoinDetailPage_lowOf24Hour.locale,
                    widget.coin.lowOf24h ?? ""),
              ),
              Expanded(
                child: currencyPriceCardItem(
                    context,
                    LocaleKeys.CoinDetailPage_highLowOf24Hour.locale,
                    widget.coin.highOf24h ?? ""),
              ),
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
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(children: [
            TextSpan(text: title + ": ", style: context.textTheme.headline6),
            TextSpan(text: price, style: context.textTheme.subtitle1)
          ]),
        ),
      ),
    );
  }

  Widget get alarmCoin => SwitchListTile(
      activeColor: context.theme.canvasColor,
      title: context.watch<CoinDetailCubit>().isAlarm == false
          ? Text(LocaleKeys.CoinDetailPage_setAlarmClose.locale)
          : Text(LocaleKeys.CoinDetailPage_setAlarmOpen.locale),
      value: context.watch<CoinDetailCubit>().isAlarm,
      onChanged: (value) =>
          context.read<CoinDetailCubit>().coinAlarmActionUI(widget.coin));
}
