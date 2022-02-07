import 'dart:async';

import '../../../../model/coin/my_coin_model.dart';

import '../../../../../core/enums/price_control.dart';
import '../../../../../core/model/response_model/response_model.dart';
import '../helper/convert_incoming_currency.dart';

class HurriyetServiceController {
  final int timerSecond = 200;

  static HurriyetServiceController? _instance;
  static HurriyetServiceController get instance {
    _instance ??= HurriyetServiceController._init();
    return _instance!;
  }

  HurriyetServiceController._init() {}

  late Timer timer;

  List<MainCurrencyModel> _previousHurriyetStocks = [];
  List<MainCurrencyModel> _lastHurriyetStocks = [];
  List<MainCurrencyModel> get getHurriyetStocks => _lastHurriyetStocks;

  Future<void> fetchHurriyetStocksEveryTwoSecond() async {
    ResponseModel<List<MainCurrencyModel>> response = await CurrencyConverter
        .instance
        .convertHurriyetStockListToMyMainCurrencyList();

    if (response.data != null) {
      _lastHurriyetStocks = response.data!;
    }

    timer = Timer.periodic(Duration(seconds: timerSecond), (timer) async {
      response = await CurrencyConverter.instance
          .convertHurriyetStockListToMyMainCurrencyList();
      if (response.data != null) {
        _lastHurriyetStocks = response.data!;
      }
      if (_previousHurriyetStocks.isEmpty != true) {
        lastPriceControl(_previousHurriyetStocks, _lastHurriyetStocks);
      }
      transferLastListToPreviousList(
          _previousHurriyetStocks, _lastHurriyetStocks);
    });
  }

  void transferLastListToPreviousList(
      List<MainCurrencyModel> previousList, List<MainCurrencyModel> lastList) {
    previousList.clear();
    for (var item in lastList) {
      previousList.add(item);
    }
  }

  void lastPriceControl(
      List<MainCurrencyModel> previousList, List<MainCurrencyModel> lastList) {
    if (lastList.length == previousList.length) {
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
}
