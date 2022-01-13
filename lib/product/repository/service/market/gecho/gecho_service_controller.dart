import 'dart:async';

import 'package:coin_with_architecture/core/model/response_model/IResponse_model.dart';

import '../../../../../core/enums/currency_enum.dart';
import '../../../../../core/enums/price_control.dart';
import '../../../../../core/model/response_model/response_model.dart';
import '../../../../model/my_coin_model.dart';
import '../helper/convert_incoming_currency.dart';

class GechoServiceController {
  final int timerSecond = 10;

  static GechoServiceController? _instance;
  static GechoServiceController get instance {
    _instance ??= GechoServiceController._init();
    return _instance!;
  }

  GechoServiceController._init() {
    _previousGechoUsdCoins = ResponseModel(data: []);
    _lastGechoUsdCoins = ResponseModel(data: []);
    _previousGechoTryCoins = ResponseModel(data: []);
    _lastGechoTryCoins = ResponseModel(data: []);
    _previousGechoBtcCoins = ResponseModel(data: []);
    _lastGechoBtcCoins = ResponseModel(data: []);
    _previousGechoEthCoins = ResponseModel(data: []);
    _lastGechoEthCoins = ResponseModel(data: []);
    _previousNewGechousdCoins = ResponseModel(data: []);
    _lastNewGechoUsdCoins = ResponseModel(data: []);
  }

  late Timer timerForUSD;
  late Timer timerForBTC;
  late Timer timerForETH;
  late Timer timerForTRY;
  late Timer timerForNEW;

  late IResponseModel<List<MainCurrencyModel>> _previousGechoUsdCoins;
  late IResponseModel<List<MainCurrencyModel>> _lastGechoUsdCoins;
  IResponseModel<List<MainCurrencyModel>> get getGechoUsdCoinList =>
      _lastGechoUsdCoins;

  late IResponseModel<List<MainCurrencyModel>> _previousGechoTryCoins;
  late IResponseModel<List<MainCurrencyModel>> _lastGechoTryCoins;
  IResponseModel<List<MainCurrencyModel>> get getGechoTryCoinList =>
      _lastGechoTryCoins;

  late IResponseModel<List<MainCurrencyModel>> _previousGechoBtcCoins;
  late IResponseModel<List<MainCurrencyModel>> _lastGechoBtcCoins;
  IResponseModel<List<MainCurrencyModel>> get getGechoBtcCoinList =>
      _lastGechoBtcCoins;

  late IResponseModel<List<MainCurrencyModel>> _previousGechoEthCoins;
  late IResponseModel<List<MainCurrencyModel>> _lastGechoEthCoins;
  IResponseModel<List<MainCurrencyModel>> get getGechoEthCoinList =>
      _lastGechoEthCoins;

  late IResponseModel<List<MainCurrencyModel>> _previousNewGechousdCoins;
  late IResponseModel<List<MainCurrencyModel>> _lastNewGechoUsdCoins;
  IResponseModel<List<MainCurrencyModel>> get getNewGechoUsdCoinList =>
      _lastNewGechoUsdCoins;

  Future<void> fetchGechoAllCoinListEveryTwoSecond() async {
    await fetchGechoUsdCoinListEveryTwoSecond();
    //await Future.delayed(Duration(milliseconds: 100));
    await fetchGechoBtcCoinListEveryTwoSecond();
    //await Future.delayed(Duration(milliseconds: 100));

    await fetchGechoTryCoinListEveryTwoSecond();
    // await Future.delayed(Duration(milliseconds: 100));
    await fetchGechoEthCoinListEveryTwoSecond();
    /* await fetchNewGechoUsdCoinListEveryTwoSecond();*/
  }

  Future<void> fetchGechoUsdCoinListEveryTwoSecond() async {
    await fetchDataTransactionForUsd();
    timerForUSD = Timer.periodic(Duration(seconds: timerSecond), (timer) async {
      await fetchDataTransactionForUsd();
      if (_previousGechoUsdCoins.data!.isNotEmpty &&
          _lastGechoUsdCoins.data!.isNotEmpty) {
        lastPriceControl(
            _previousGechoUsdCoins.data!, _lastGechoUsdCoins.data!);
      }
      transferLastListToPreviousList(
          _previousGechoUsdCoins.data!, _lastGechoUsdCoins.data!);
    });
  }

  Future<void> fetchGechoBtcCoinListEveryTwoSecond() async {
    await fetchDataTransactionForBtc();
    timerForBTC = Timer.periodic(Duration(seconds: timerSecond), (timer) async {
      await fetchDataTransactionForBtc();
      if (_previousGechoBtcCoins.data!.isNotEmpty &&
          _lastGechoBtcCoins.data!.isNotEmpty) {
        lastPriceControl(
            _previousGechoBtcCoins.data!, _lastGechoBtcCoins.data!);
      }

      transferLastListToPreviousList(
          _previousGechoBtcCoins.data!, _lastGechoBtcCoins.data!);
    });
  }

  Future<void> fetchGechoTryCoinListEveryTwoSecond() async {
    await fetchDataTransactionForTry();
    timerForTRY = Timer.periodic(Duration(seconds: timerSecond), (timer) async {
      await fetchDataTransactionForTry();
      if (_previousGechoTryCoins.data!.isNotEmpty &&
          _lastGechoTryCoins.data!.isNotEmpty) {
        lastPriceControl(
            _previousGechoTryCoins.data!, _lastGechoTryCoins.data!);
      }
      transferLastListToPreviousList(
          _previousGechoTryCoins.data!, _lastGechoTryCoins.data!);
    });
  }

  Future<void> fetchGechoEthCoinListEveryTwoSecond() async {
    await fetchDataTransactionForEth();
    timerForETH = Timer.periodic(Duration(seconds: timerSecond), (timer) async {
      await fetchDataTransactionForEth();
      if (_previousGechoEthCoins.data!.isNotEmpty &&
          _lastGechoEthCoins.data!.isNotEmpty) {
        lastPriceControl(
            _previousGechoEthCoins.data!, _lastGechoEthCoins.data!);
      }
      transferLastListToPreviousList(
          _previousGechoEthCoins.data!, _lastGechoEthCoins.data!);
    });
  }

  Future<void> fetchDataTransactionForUsd() async {
    ResponseModel<List<MainCurrencyModel>> responseUSD =
        await getFromCurrencyConverter(CoinCurrency.USD.name);
    ResponseModel<List<MainCurrencyModel>> responseNEW =
        await getFromCurrencyConverter(CoinCurrency.USD.name,
            idList: ["ninja-squad", "talecraft", "colony", "bitcoin"]);
    if (responseUSD.error != null) {
      responseUSD = responseUSD;
    } else if (responseUSD.data != null) {
      if (responseNEW.data != null && responseNEW.data!.isNotEmpty) {
        print(responseNEW.data!.length);
        print("***************************************");
        responseUSD.data?.addAll(responseNEW.data!);
      }
      _lastGechoUsdCoins = responseUSD;
      percentageControl(_lastGechoUsdCoins.data!);
    }
  }

  Future<void> fetchDataTransactionForTry() async {
    ResponseModel<List<MainCurrencyModel>> responseTRY =
        await getFromCurrencyConverter(CoinCurrency.TRY.name);
    if (responseTRY.error != null) {
      responseTRY = responseTRY;
    } else if (responseTRY.data != null) {
      _lastGechoTryCoins = responseTRY;
      percentageControl(_lastGechoTryCoins.data!);
    }
  }

  Future<void> fetchDataTransactionForBtc() async {
    ResponseModel<List<MainCurrencyModel>> responseBTC =
        await getFromCurrencyConverter(CoinCurrency.BTC.name);

    if (responseBTC.error != null) {
      responseBTC = responseBTC;
    } else if (responseBTC.data != null) {
      _lastGechoBtcCoins = responseBTC;
      percentageControl(_lastGechoBtcCoins.data!);
    }
  }

  Future<void> fetchDataTransactionForEth() async {
    ResponseModel<List<MainCurrencyModel>> responseETH =
        await getFromCurrencyConverter(CoinCurrency.TRY.name);
    if (responseETH.error != null) {
      responseETH = responseETH;
    } else if (responseETH.data != null) {
      _lastGechoEthCoins = responseETH;
      percentageControl(_lastGechoEthCoins.data!);
    }
  }
  /* Future<void> fetchNewGechoUsdCoinListEveryTwoSecond() async {
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
  }*/

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
