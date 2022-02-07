import 'dart:async';

import '../../../../model/coin/my_coin_model.dart';

import '../../../../../core/enums/price_control.dart';
import '../../../../../core/model/response_model/response_model.dart';
import '../helper/convert_incoming_currency.dart';

class GenelParaServiceController {
  final int timerSecond = 200;

  static GenelParaServiceController? _instance;
  static GenelParaServiceController get instance {
    _instance ??= GenelParaServiceController._init();
    return _instance!;
  }

  GenelParaServiceController._init() {
    _previousGenelParaStocks = ResponseModel(data: []);
    _lastGenelParaStocks = ResponseModel(data: []);
  }

  late Timer timer;

  late ResponseModel<List<MainCurrencyModel>> _previousGenelParaStocks;
  late ResponseModel<List<MainCurrencyModel>> _lastGenelParaStocks;
  ResponseModel<List<MainCurrencyModel>> get getGenelParaStocks =>
      _lastGenelParaStocks;

  Future<void> fetchGenelParaStocksEveryTwoSecond() async {
    await fetchDataTransactions();
    timer = Timer.periodic(Duration(seconds: timerSecond), (timer) async {
      await fetchDataTransactions();
      if (_previousGenelParaStocks.data != null &&
          _lastGenelParaStocks.data != null) {
        if (_previousGenelParaStocks.data!.isNotEmpty &&
            _lastGenelParaStocks.data!.isNotEmpty) {
          lastPriceControl(
              _previousGenelParaStocks.data!,
              _lastGenelParaStocks
                  .data!); // _last general para stock boş gelme ihtimali var mı
        }
      }
      if (_previousGenelParaStocks.data != null &&
          _lastGenelParaStocks.data != null) {
        transferLastListToPreviousList(
            _previousGenelParaStocks.data!, _lastGenelParaStocks.data!);
      }
    });
  }

  Future<void> fetchDataTransactions() async {
    ResponseModel<List<MainCurrencyModel>> response = await CurrencyConverter
        .instance
        .convertGenelParaStockListToMyMainCurrencyList();
    if (response.error != null) {
      _lastGenelParaStocks = ResponseModel<List<MainCurrencyModel>>(
          data: _lastGenelParaStocks.data, error: response.error);
    } else if (response.data != null) {
      _lastGenelParaStocks = response;
    } else {
      //TODO:BUNU YAPMAMA GEREK VAR MI
      _lastGenelParaStocks = ResponseModel<List<MainCurrencyModel>>(
          data: _lastGenelParaStocks.data);
    }
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
