import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:coin_with_architecture/core/enums/currency_enum.dart';
import 'package:coin_with_architecture/core/enums/price_control.dart';
import 'package:coin_with_architecture/product/model/my_coin_model.dart';
import 'package:flutter/material.dart';
import 'package:persian_tools/src/core/commas/commas.dart';

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
  Color getColorForPercentage() {
    if (widget.coin.percentageControl == PriceLevelControl.INCREASING.name) {
      return Colors.green;
    } else if (widget.coin.percentageControl ==
        PriceLevelControl.DESCREASING.name) {
      return Colors.red;
    } else {
      return Colors.black;
    }
  }
  /* DateTime now = DateTime.now();
  Text(
          (now.hour.toString() +
              ":" +
              now.minute.toString() +
              ":" +
              now.second.toString()),
          style: TextStyle(fontSize: 10),
        ),*/

  Color getColorForPrice() {
    if (widget.coin.priceControl == PriceLevelControl.INCREASING.name) {
      return Colors.green;
    } else if (widget.coin.priceControl == PriceLevelControl.DESCREASING.name) {
      return Colors.red;
    } else {
      return Colors.black;
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

  @override
  Widget build(BuildContext context) {
    widget.coin.lastPrice?.length;
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            buildFavoriteButton(),
            Expanded(flex: 4, child: buildCurrencyName()),
            Expanded(flex: 10, child: buildCurrencyPrice()),
            Expanded(flex: 5, child: buildPercentageBox()),
          ],
        ),
      ),
    );
  }

  IconButton buildFavoriteButton() {
    return IconButton(
        padding: EdgeInsets.only(
            left: 0,
            right: 8), //EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        constraints: BoxConstraints.tightForFinite(),
        onPressed: () {
          widget.coin.isFavorite = !widget.coin.isFavorite;

          widget.voidCallback();
          // context.read<CoinListCubit>().saveDeleteFromFavorites(widget.result);///for list
          setState(() {});
        },
        icon: widget.coin.isFavorite
            ? Icon(
                Icons.star_rounded,
                // color: Theme.of(context).ic,
                size: MediaQuery.of(context).size.height / 33,
              )
            : Icon(
                Icons.star_border_rounded,
                //color: Colors.yellow[600],
                size: MediaQuery.of(context).size.height / 33,
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
              style:
                  Theme.of(context).textTheme.headline6!.copyWith(fontSize: 16),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width / 150,
            ),
            widget.coin.isAlarmActive == true
                ? Icon(
                    Icons.alarm,
                    size: MediaQuery.of(context).size.width / 25,
                  )
                : Text(
                    "",
                    style: TextStyle(fontSize: 0),
                  ),
          ],
        ),
        widget.coin.lastUpdate != null
            ? Text(
                widget.coin.lastUpdate!,
                style: TextStyle(fontSize: 10),
              )
            : Text(
                "",
                style: TextStyle(fontSize: 0),
              ),
      ],
    );
  }

  AutoSizeText buildCurrencyPrice() {
    String price =
        double.parse((widget.coin.lastPrice ?? "0")).toStringAsFixed(2);
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
            vertical: MediaQuery.of(context).size.height / 90,
            horizontal: MediaQuery.of(context).size.width / 100,
          ),
          child: buildCurrenctPercentageText(),
          color: getColorForPercentage()),
    );
  }

  AutoSizeText buildCurrenctPercentageText() {
    String price =
        double.parse((widget.coin.changeOf24H ?? "0")).toStringAsFixed(2);
    return AutoSizeText(
      price + " %",
      maxLines: 1,
      minFontSize: 10,
      style: TextStyle(
        color: Theme.of(context).colorScheme.background,
      ),
    );
  }
}
