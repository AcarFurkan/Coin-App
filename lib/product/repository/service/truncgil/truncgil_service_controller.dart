import 'dart:async';

import 'package:coin_with_architecture/core/enums/price_control.dart';
import 'package:coin_with_architecture/core/model/response_model/response_model.dart';
import 'package:coin_with_architecture/product/model/my_coin_model.dart';
import 'package:coin_with_architecture/product/repository/service/helper/convert_incoming_currency.dart';

class TruncgilServiceController {
  final int timerSecond = 5;

  static CurrencyConverter? _currencyConverter;

  static TruncgilServiceController? _instance;
  static TruncgilServiceController get instance {
    _instance ??= TruncgilServiceController._init();
    return _instance!;
  }

  TruncgilServiceController._init() {
    _currencyConverter = CurrencyConverter.instance;
  }

  late Timer timer;

  List<MainCurrencyModel> _previousTruncgilList = [];
  List<MainCurrencyModel> _lastTruncgilList = [];
  List<MainCurrencyModel> get getTruncgilList => _lastTruncgilList;

  Future<void> fetchTruncgilListEveryTwoSecond() async {
    ResponseModel<List<MainCurrencyModel>> response = await CurrencyConverter
        .instance
        .convertTruncgilListToMyMainCurrencyList();

    if (response.data != null) {
      _lastTruncgilList = response.data!;
      percentageControl(_lastTruncgilList);
    }

    timer = Timer.periodic(Duration(seconds: timerSecond), (timer) async {
      response = await CurrencyConverter.instance
          .convertTruncgilListToMyMainCurrencyList();
      if (response.data != null) {
        _lastTruncgilList = response.data!;
        percentageControl(_lastTruncgilList);
      }
      if (_previousTruncgilList.isEmpty != true) {
        lastPriceControl(_previousTruncgilList, _lastTruncgilList);
      }
      transferLastListToPreviousList(_previousTruncgilList, _lastTruncgilList);
    });
  }

  void transferLastListToPreviousList(
      List<MainCurrencyModel> previousList, List<MainCurrencyModel> lastList) {
    previousList.clear();
    for (var item in lastList) {
      previousList.add(item);
    }
  }

  void percentageControl(List<MainCurrencyModel> coin) async {
    for (var item in coin) {
      String result = item.changeOf24H ?? "";
      if (result[0] == "-") {
        item.percentageControl = PriceLevelControl.DESCREASING.name;
      } else if (result == "0.0") {
        //  L AM NOT SURE FOR THIS TRY IT
        item.percentageControl = PriceLevelControl.CONSTANT.name;
      } else {
        item.percentageControl = PriceLevelControl.INCREASING.name;
      }
    }
  }

  void lastPriceControl(
      List<MainCurrencyModel> previousList, List<MainCurrencyModel> lastList) {
    for (var i = 0; i < lastList.length; i++) {
      double lastPrice = double.parse(lastList[i].lastPrice ?? "0");
      double previousPrice = double.parse(previousList[i].lastPrice ?? "0");
      if (lastPrice > previousPrice) {
        lastList[i].priceControl = PriceLevelControl.INCREASING.name;
      } else if (previousPrice > lastPrice) {
        lastList[i].priceControl = PriceLevelControl.DESCREASING.name;
      } else {
        lastList[i].priceControl = PriceLevelControl.CONSTANT.name;
      }
    }
  }
}
