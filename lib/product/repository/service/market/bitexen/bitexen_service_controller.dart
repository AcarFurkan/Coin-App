import 'dart:async';

import 'package:coin_with_architecture/core/model/response_model/IResponse_model.dart';

import '../../../../../core/enums/price_control.dart';
import '../../../../../core/model/response_model/response_model.dart';
import '../../../../model/my_coin_model.dart';
import '../helper/convert_incoming_currency.dart';

class BitexenServiceController {
  final int timerSecond = 2;

  static BitexenServiceController? _instance;
  static BitexenServiceController get instance {
    _instance ??= BitexenServiceController._init();
    return _instance!;
  }

  BitexenServiceController._init() {
    _previousbitexenCoins = ResponseModel(data: []);
    _lastbitexenCoins = ResponseModel(data: []);
  }

  late Timer timer;

  late IResponseModel<List<MainCurrencyModel>> _previousbitexenCoins;
  late IResponseModel<List<MainCurrencyModel>> _lastbitexenCoins;
  IResponseModel<List<MainCurrencyModel>> get getBitexenCoins =>
      _lastbitexenCoins;

  Future<void> fetchBitexenCoinListEveryTwoSecond() async {
    await fetchDataTrarnsactions();
    timer = Timer.periodic(Duration(seconds: timerSecond), (timer) async {
      await fetchDataTrarnsactions();
      if (_previousbitexenCoins.data!.isNotEmpty &&
          _lastbitexenCoins.data!.isNotEmpty) {
        lastPriceControl(_previousbitexenCoins.data!, _lastbitexenCoins.data!);
      }
      transferLastListToPreviousList(
          _previousbitexenCoins.data!, _lastbitexenCoins.data!);
    });
  }

  Future<void> fetchDataTrarnsactions() async {
    ResponseModel<List<MainCurrencyModel>> response =
        await CurrencyConverter.instance.convertBitexenListCoinToMyCoinList();
    if (response.error != null) {
      _lastbitexenCoins = response;
    } else if (response.data != null) {
      _lastbitexenCoins = response;
      percentageControl(_lastbitexenCoins.data!);
    }
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
