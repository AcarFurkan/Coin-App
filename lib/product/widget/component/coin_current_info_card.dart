import 'package:auto_size_text/auto_size_text.dart';
import '../../model/coin/my_coin_model.dart';
import 'package:flutter/material.dart';
import 'package:persian_tools/src/core/commas/commas.dart';

import '../../../core/enums/currency_enum.dart';
import '../../../core/enums/price_control.dart';
import '../../../core/extension/context_extension.dart';

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
            Expanded(flex: 4, child: buildCurrencyName()),
            Expanded(flex: 7, child: buildCurrencyPrice()),
            Expanded(flex: 5, child: buildPercentageBox()),
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
        SizedBox(
          width: MediaQuery.of(context).size.width / 5,
          child: Row(
            children: [
              widget.coin.isAlarmActive == true
                  ? Icon(
                      Icons.alarm,
                      size: context.width / 25,
                    )
                  : Container(),
              widget.coin.isAlarmActive == true
                  ? SizedBox(
                      width: context.width / 150,
                    )
                  : Container(),
              SizedBox(
                width: widget.coin.isAlarmActive == true
                    ? MediaQuery.of(context).size.width / 7
                    : MediaQuery.of(context).size.width / 5.5,
                child: AutoSizeText(
                  widget.coin.name.toUpperCase(),
                  minFontSize: 5,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                  presetFontSizes: const [14, 12, 10, 8],
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ],
          ),
        ),
        widget.coin.lastUpdate != null
            ? AutoSizeText(
                widget.coin.lastUpdate!,
                maxLines: 1,
                presetFontSizes: const [10, 8, 6],
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

  void percentageControl() async {
    String result = widget.coin.changeOf24H ?? "";

    if (result == "") {
      widget.coin.percentageControl = PriceLevelControl.INCREASING.name;
    } else if (result == "0.0") {
      //  L AM NOT SURE FOR THIS TRY IT
      widget.coin.percentageControl = PriceLevelControl.CONSTANT.name;
    } else if (result[0] == "-") {
      widget.coin.percentageControl = PriceLevelControl.DESCREASING.name;
    } else {
      widget.coin.percentageControl = PriceLevelControl.INCREASING.name;
    }
  }

  Color getColorForPercentage() {
    percentageControl();
    if (widget.coin.percentageControl == PriceLevelControl.INCREASING.name) {
      return context.theme.indicatorColor;
    } else if (widget.coin.percentageControl ==
        PriceLevelControl.DESCREASING.name) {
      return context.colors.error;
    } else {
      return context.theme.indicatorColor;
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
