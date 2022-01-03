import 'dart:async';
import '../../../../core/enums/price_control.dart';
import '../../../../core/model/response_model/response_model.dart';
import '../../../model/my_coin_model.dart';
import '../helper/convert_incoming_currency.dart';

class GenelParaServiceController {
  final int timerSecond = 200;

  static CurrencyConverter? _currencyConverter;

  static GenelParaServiceController? _instance;
  static GenelParaServiceController get instance {
    _instance ??= GenelParaServiceController._init();
    return _instance!;
  }

  GenelParaServiceController._init() {
    _currencyConverter = CurrencyConverter.instance;
  }

  late Timer timer;

  List<MainCurrencyModel> _previousGenelParaStocks = [];
  List<MainCurrencyModel> _lastGenelParaStocks = [];
  List<MainCurrencyModel> get getGenelParaStocks => _lastGenelParaStocks;

  Future<void> fetchGenelParaStocksEveryTwoSecond() async {
    ResponseModel<List<MainCurrencyModel>> response = await CurrencyConverter
        .instance
        .convertGenelParaStockListToMyMainCurrencyList();

    if (response.data != null) {
      _lastGenelParaStocks = response.data!;
      percentageControl(_lastGenelParaStocks);
    }

    timer = Timer.periodic(Duration(seconds: timerSecond), (timer) async {
      response = await CurrencyConverter.instance
          .convertGenelParaStockListToMyMainCurrencyList();
      if (response.data != null) {
        _lastGenelParaStocks = response.data!;
        percentageControl(_lastGenelParaStocks);
      }
      if (_previousGenelParaStocks.isEmpty != true) {
        lastPriceControl(_previousGenelParaStocks, _lastGenelParaStocks);
      }
      transferLastListToPreviousList(
          _previousGenelParaStocks, _lastGenelParaStocks);
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
