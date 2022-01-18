import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:persian_tools/src/core/commas/commas.dart';

import '../../../core/enums/currency_enum.dart';
import '../../../core/enums/price_control.dart';
import '../../../core/extension/context_extension.dart';
import '../../model/my_coin_model.dart';

class ListCardItem extends StatefulWidget {
  const ListCardItem({
    Key? key,
    required this.coin,
    this.index,
    required this.voidCallback,
  }) : super(key: key);

  final MainCurrencyModel coin;
  final int? index;
  final VoidCallback voidCallback;

  @override
  State<ListCardItem> createState() => _ListCardItemState();
}

class _ListCardItemState extends State<ListCardItem> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: context.lowValue * 1.3, vertical: context.lowValue),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            buildFavoriteButton(),
            Expanded(
                flex: (context.lowValue * 0.7).toInt(),
                child: buildCurrencyName()),
            Expanded(
                flex: context.lowValue.toInt() * 2,
                child: buildCurrencyPrice()),
            Expanded(
                flex: context.lowValue.toInt(), child: buildPercentageBox()),
          ],
        ),
      ),
    );
  }

  IconButton buildFavoriteButton() {
    return IconButton(
        padding: EdgeInsets.only(right: context.lowValue),
        constraints: const BoxConstraints.tightForFinite(),
        onPressed: () {
          widget.coin.isFavorite = !widget.coin.isFavorite;
          widget.voidCallback();
          setState(() {});
        },
        icon: widget.coin.isFavorite
            ? Icon(
                Icons.star_rounded,
                size: context.height / 33,
              )
            : Icon(
                Icons.star_border_rounded,
                size: context.height / 33,
              ));
  }

  Widget buildCurrencyName() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            // Text((widget.index ?? "").toString()),

            Text(
              widget.coin.name.toUpperCase(),
              style: context.textTheme.subtitle1,
            ),
            SizedBox(
              width: context.width / 150,
            ),
            widget.coin.isAlarmActive == true
                ? Icon(
                    Icons.alarm,
                    size: context.width / 25,
                  )
                : Container(),
          ],
        ),
        widget.coin.lastUpdate != null
            ? Text(
                widget.coin.lastUpdate!,
                style: context.textTheme.overline,
              )
            : Container()
      ],
    );
  }

  AutoSizeText buildCurrencyPrice() {
    String price =
        double.parse((widget.coin.lastPrice ?? "0")).toStringAsFixed(5);
    return AutoSizeText(
      "${price.addComma} $currencyIcon",
      textAlign: TextAlign.center,
      style: TextStyle(color: getColorForPrice()),
    );
  }

  Widget buildPercentageBox() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(
            vertical: context.height / 90,
            horizontal: context.width / 100,
          ),
          child: buildCurrenctPercentageText(),
          color: getColorForPercentage()),
    );
  }

  AutoSizeText buildCurrenctPercentageText() {
    try {
      String price =
          double.parse((widget.coin.changeOf24H ?? "0")).toStringAsFixed(2);
      return AutoSizeText(
        price + " %",
        maxLines: 1,
        minFontSize: 10,
        style: TextStyle(
          color: context.colors.onError,
        ),
      );
    } catch (e) {
      return AutoSizeText(
        "0 %",
        maxLines: 1,
        minFontSize: 10,
        style: TextStyle(
          color: context.colors.background,
        ),
      );
    }
  }

  Color getColorForPercentage() {
    if (widget.coin.percentageControl == PriceLevelControl.INCREASING.name) {
      return context.theme.indicatorColor;
    } else if (widget.coin.percentageControl ==
        PriceLevelControl.DESCREASING.name) {
      return context.colors.error;
    } else {
      return context.colors.onBackground;
    }
  }

  Color getColorForPrice() {
    if (widget.coin.priceControl == PriceLevelControl.INCREASING.name) {
      return context.theme.indicatorColor;
    } else if (widget.coin.priceControl == PriceLevelControl.DESCREASING.name) {
      return context.colors.error;
    } else {
      return context.colors.onBackground;
    }
  }

  String get currencyIcon {
    return widget.coin.counterCurrencyCode == CoinCurrency.USD.name
        ? "\$"
        : widget.coin.counterCurrencyCode == CoinCurrency.TRY.name
            ? "₺"
            : widget.coin.counterCurrencyCode == CoinCurrency.ETH.name
                ? "♦"
                : widget.coin.counterCurrencyCode == CoinCurrency.BTC.name
                    ? "₿"
                    : "\$";
  }
}
