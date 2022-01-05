import 'dart:async';

import '../../../../../core/enums/currency_enum.dart';
import '../../../../../core/enums/price_control.dart';
import '../../../../../core/model/response_model/response_model.dart';
import '../../../../model/my_coin_model.dart';

import '../helper/convert_incoming_currency.dart';

class GechoServiceController {
  final int timerSecond = 10;
  static CurrencyConverter? _currencyConverter;

  static GechoServiceController? _instance;
  static GechoServiceController get instance {
    _instance ??= GechoServiceController._init();
    return _instance!;
  }

  GechoServiceController._init() {
    _currencyConverter = CurrencyConverter.instance;
  }

  late Timer timerForUSD;
  late Timer timerForBTC;
  late Timer timerForETH;
  late Timer timerForTRY;
  late Timer timerForNEW;

  List<MainCurrencyModel> _previousGechoUsdCoins = [];
  List<MainCurrencyModel> _lastGechoUsdCoins = [];
  List<MainCurrencyModel> get getGechoUsdCoinList => _lastGechoUsdCoins;

  List<MainCurrencyModel> _previousGechoTryCoins = [];
  List<MainCurrencyModel> _lastGechoTryCoins = [];
  List<MainCurrencyModel> get getGechoTryCoinList => _lastGechoTryCoins;

  List<MainCurrencyModel> _previousGechoBtcCoins = [];
  List<MainCurrencyModel> _lastGechoBtcCoins = [];
  List<MainCurrencyModel> get getGechoBtcCoinList => _lastGechoBtcCoins;

  List<MainCurrencyModel> _previousGechoEthCoins = [];
  List<MainCurrencyModel> _lastGechoEthCoins = [];
  List<MainCurrencyModel> get getGechoEthCoinList => _lastGechoEthCoins;

  List<MainCurrencyModel> _previousNewGechousdCoins = [];
  List<MainCurrencyModel> _lastNewGechoUsdCoins = [];
  List<MainCurrencyModel> get getNewGechoUsdCoinList => _lastNewGechoUsdCoins;

  Future<void> fetchGechoAllCoinListEveryTwoSecond() async {
    await fetchGechoUsdCoinListEveryTwoSecond();
    //await Future.delayed(Duration(milliseconds: 100));
    await fetchGechoBtcCoinListEveryTwoSecond();
    //await Future.delayed(Duration(milliseconds: 100));

    await fetchGechoTryCoinListEveryTwoSecond();
    // await Future.delayed(Duration(milliseconds: 100));
    await fetchGechoEthCoinListEveryTwoSecond();
    await fetchNewGechoUsdCoinListEveryTwoSecond();
  }

  Future<void> fetchGechoUsdCoinListEveryTwoSecond() async {
    ResponseModel<List<MainCurrencyModel>> responseUSD =
        await getFromCurrencyConverter(CoinCurrency.USD.name);
    ResponseModel<List<MainCurrencyModel>> responseNEW =
        await getFromCurrencyConverter(CoinCurrency.USD.name,
            idList: ["ninja-squad", "talecraft", "colony", "bitcoin"]);

    if (responseUSD.data != null) {
      if (responseNEW.data != null) {
        responseUSD.data?.addAll(responseNEW.data!);
      }
      _lastGechoUsdCoins = responseUSD.data!;
      percentageControl(_lastGechoUsdCoins);
    }
    timerForUSD = Timer.periodic(Duration(seconds: timerSecond), (timer) async {
      responseUSD = await getFromCurrencyConverter(CoinCurrency.USD.name);
      ResponseModel<List<MainCurrencyModel>> responseNEW =
          await getFromCurrencyConverter(CoinCurrency.USD.name,
              idList: ["ninja-squad", "talecraft", "colony", "bitcoin"]);
      if (responseUSD.data != null) {
        if (responseNEW.data != null) {
          responseUSD.data?.addAll(responseNEW.data!);
        }
        _lastGechoUsdCoins = responseUSD.data!;
        percentageControl(_lastGechoUsdCoins);
      }
      if (_previousGechoUsdCoins.isEmpty != true) {
        lastPriceControl(_previousGechoUsdCoins, _lastGechoUsdCoins);
      }

      transferLastListToPreviousList(
          _previousGechoUsdCoins, _lastGechoUsdCoins);
    });
  }

  Future<void> fetchGechoBtcCoinListEveryTwoSecond() async {
    ResponseModel<List<MainCurrencyModel>> responseBTC =
        await getFromCurrencyConverter(CoinCurrency.BTC.name);

    if (responseBTC.data != null) {
      _lastGechoBtcCoins = responseBTC.data!;
      percentageControl(_lastGechoBtcCoins);
    }
    timerForBTC = Timer.periodic(Duration(seconds: timerSecond), (timer) async {
      responseBTC = await getFromCurrencyConverter(CoinCurrency.BTC.name);
      if (responseBTC.data != null) {
        _lastGechoBtcCoins = responseBTC.data!;
        percentageControl(_lastGechoBtcCoins);
      }
      if (_previousGechoBtcCoins.isEmpty != true) {
        lastPriceControl(_previousGechoBtcCoins, _lastGechoBtcCoins);
      }

      transferLastListToPreviousList(
          _previousGechoBtcCoins, _lastGechoBtcCoins);
    });
  }

  Future<void> fetchGechoTryCoinListEveryTwoSecond() async {
    ResponseModel<List<MainCurrencyModel>> responseTRY =
        await getFromCurrencyConverter(CoinCurrency.TRY.name);
    if (responseTRY.data != null) {
      _lastGechoTryCoins = responseTRY.data!;
      percentageControl(_lastGechoTryCoins);
    }
    timerForTRY = Timer.periodic(Duration(seconds: timerSecond), (timer) async {
      responseTRY = await getFromCurrencyConverter(CoinCurrency.TRY.name);
      if (responseTRY.data != null) {
        _lastGechoTryCoins = responseTRY.data!;
        percentageControl(_lastGechoTryCoins);
      }
      if (_previousGechoTryCoins.isEmpty != true) {
        lastPriceControl(_previousGechoTryCoins, _lastGechoTryCoins);
      }

      transferLastListToPreviousList(
          _previousGechoTryCoins, _lastGechoTryCoins);
    });
  }

  Future<void> fetchGechoEthCoinListEveryTwoSecond() async {
    ResponseModel<List<MainCurrencyModel>> responseETH =
        await getFromCurrencyConverter(CoinCurrency.ETH.name);
    if (responseETH.data != null) {
      _lastGechoEthCoins = responseETH.data!;

      percentageControl(_lastGechoEthCoins);
    }
    timerForETH = Timer.periodic(Duration(seconds: timerSecond), (timer) async {
      responseETH = await getFromCurrencyConverter(CoinCurrency.ETH.name);
      if (responseETH.data != null) {
        percentageControl(responseETH.data!);
      }
      if (_previousGechoEthCoins.isEmpty != true) {
        lastPriceControl(_previousGechoEthCoins, _lastGechoEthCoins);
      }
      transferLastListToPreviousList(
          _previousGechoEthCoins, _lastGechoEthCoins);
    });
  }

  Future<void> fetchNewGechoUsdCoinListEveryTwoSecond() async {
    ResponseModel<List<MainCurrencyModel>> responseNEW =
        await getFromCurrencyConverter(CoinCurrency.USD.name,
            idList: ["ninja-squad", "talecraft", "colony", "bitcoin"]);
    if (responseNEW.data != null) {
      _lastNewGechoUsdCoins = responseNEW.data!;
      percentageControl(_lastNewGechoUsdCoins);
    }
    timerForNEW = Timer.periodic(Duration(seconds: timerSecond), (timer) async {
      responseNEW = await getFromCurrencyConverter(CoinCurrency.USD.name,
          idList: ["ninja-squad", "talecraft", "colony", "bitcoin"]);

      if (responseNEW.data != null) {
        percentageControl(responseNEW.data!);
      }
      if (_previousNewGechousdCoins.isEmpty != true) {
        lastPriceControl(_previousNewGechousdCoins, _lastNewGechoUsdCoins);
      }
      transferLastListToPreviousList(
          _previousNewGechousdCoins, _lastNewGechoUsdCoins);
    });
  }

  void transferLastListToPreviousList(
      List<MainCurrencyModel> previousList, List<MainCurrencyModel> lastList) {
    previousList.clear();
    for (var item in lastList) {
      previousList.add(item);
    }
  }

  Future<ResponseModel<List<MainCurrencyModel>>> getFromCurrencyConverter(
      String currency,
      {List<String>? idList}) async {
    ResponseModel<List<MainCurrencyModel>> response = await CurrencyConverter
        .instance
        .convertGechoCoinListByCurrencyToMyCoinList(currency, idList: idList);
    return response;
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
