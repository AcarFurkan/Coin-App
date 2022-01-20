import 'package:auto_size_text/auto_size_text.dart';
import 'package:coin_with_architecture/core/enums/price_control.dart';
import 'package:coin_with_architecture/core/extension/context_extension.dart';
import 'package:coin_with_architecture/product/model/coin/my_coin_model.dart';
import '../../../core/enums/currency_enum.dart';
import '../../../features/coin/selected_coin/viewmodel/cubit/coin_cubit.dart';
import 'package:flutter/material.dart';
import 'package:persian_tools/src/core/commas/commas.dart';
import 'package:provider/src/provider.dart';

class RemovableCardItem extends StatefulWidget {
  RemovableCardItem(
      {Key? key,
      required this.currency,
      required this.context,
      required this.isSelectedAll})
      : super(key: key);
  final MainCurrencyModel currency;
  final BuildContext context;
  bool isSelectedAll;

  @override
  State<RemovableCardItem> createState() => _RemovableCardItemState();
}

class _RemovableCardItemState extends State<RemovableCardItem> {
  Color getColorForPrice() {
    if (widget.currency.priceControl == PriceLevelControl.INCREASING.name) {
      return context.theme.indicatorColor;
    } else if (widget.currency.priceControl ==
        PriceLevelControl.DESCREASING.name) {
      return context.colors.error;
    } else {
      return context.colors.onBackground;
    }
  }

  Color getColorForPercentage() {
    if (widget.currency.percentageControl ==
        PriceLevelControl.INCREASING.name) {
      return context.theme.indicatorColor;
    } else if (widget.currency.percentageControl ==
        PriceLevelControl.DESCREASING.name) {
      return context.colors.error;
    } else {
      return context.theme.indicatorColor;
    }
  }

  String get currencyIcon {
    return widget.currency.counterCurrencyCode == CoinCurrency.USD.name
        ? "\$"
        : widget.currency.counterCurrencyCode == CoinCurrency.TRY.name
            ? "₺"
            : widget.currency.counterCurrencyCode == CoinCurrency.ETH.name
                ? "♦"
                : widget.currency.counterCurrencyCode == CoinCurrency.BTC.name
                    ? "₿"
                    : "\$";
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTapAction();
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(flex: 4, child: buildCurrencyName()),
              Expanded(flex: 10, child: buildCurrencyPrice()),
              Expanded(flex: 5, child: buildPercentageBox),
              const Spacer(),
              buildRemoveCircle,

              // Icon
            ],
          ),
        ),
      ),
    );
  }

  AutoSizeText buildCurrencyPrice() {
    String price =
        double.parse((widget.currency.lastPrice ?? "0")).toStringAsFixed(5);
    return AutoSizeText(
      "${price.addComma} $currencyIcon",
      textAlign: TextAlign.center,
      style: TextStyle(color: getColorForPrice()),
    );
  }

  Widget buildCurrencyName() {
    return Row(
      children: [
        buildNameText,
        SizedBox(
          width: context.width / 150,
        ),
        buildAlarmIcon
      ],
    );
  }

  Widget get buildAlarmIcon => widget.currency.isAlarmActive == true
      ? Icon(
          Icons.alarm,
          size: context.width / 25,
        )
      : Container();

  Text get buildNameText => Text(
        widget.currency.name.toUpperCase(),
        style: context.textTheme.headline6!.copyWith(fontSize: 16),
      );

  AutoSizeText buildCurrenctPercentageText() {
    String price =
        double.parse((widget.currency.changeOf24H ?? "0")).toStringAsFixed(2);
    return AutoSizeText(
      price + " %",
      maxLines: 1,
      minFontSize: 10,
      style: TextStyle(
        color: context.colors.onError,
      ),
    );
  }

  Widget get buildPercentageBox => ClipRRect(
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

  Container get buildRemoveCircle => Container(
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: const BorderRadius.all(Radius.circular(15))),
        child: Opacity(opacity: rr(), child: const Icon(Icons.close)),
      );

  double rr() {
    if (widget.isSelectedAll == true) {
      context.read<CoinCubit>().addItemToBeDeletedList(widget.currency.id);
      return 1;
    } else {
      context.read<CoinCubit>().removeItemFromBeDeletedList(widget.currency.id);
      return 0;
    }
  }

  void onTapAction() {
    setState(() {
      widget.isSelectedAll = !widget.isSelectedAll;
    });
  }
}
