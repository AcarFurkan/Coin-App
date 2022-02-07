import 'dart:async';

import '../../../../model/coin/my_coin_model.dart';
import '../../../cache/added_coin_list_externally_cache_manager.dart';

import '../../../../../core/model/response_model/IResponse_model.dart';

import '../../../../../core/enums/currency_enum.dart';
import '../../../../../core/enums/price_control.dart';
import '../../../../../core/model/response_model/response_model.dart';
import '../../../../../locator.dart';
import '../helper/convert_incoming_currency.dart';

class GechoServiceController {
  final int timerSecond = 10;

  static GechoServiceController? _instance;
  static GechoServiceController get instance {
    _instance ??= GechoServiceController._init();
    return _instance!;
  }

  final AddedCoinListExternally _listCoinIdCacheManager =
      locator<AddedCoinListExternally>();

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
  List<String> coinsToBeAdded = [];

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
    await fetchNewGechoUsdCoinListEveryTwoSecond();
  }

  Future<void> fetchNewGechoUsdCoinListEveryTwoSecond() async {
    await fetchNewGechoUsdCoinListTransactionForUsd();
    timerForUSD = Timer.periodic(Duration(seconds: timerSecond), (timer) async {
      await fetchNewGechoUsdCoinListTransactionForUsd();
      if (_previousNewGechousdCoins.data != null &&
          _lastNewGechoUsdCoins.data != null) {
        if (_previousNewGechousdCoins.data!.isNotEmpty &&
            _lastNewGechoUsdCoins.data!.isNotEmpty) {
          lastPriceControl(_previousNewGechousdCoins.data!,
              _lastNewGechoUsdCoins.data!); // TODO: FİX NULL CHECK
        }
        transferLastListToPreviousList(
            _previousNewGechousdCoins.data!, _lastNewGechoUsdCoins.data!);
      }
    });
  }

  Future<void> fetchGechoUsdCoinListEveryTwoSecond() async {
    await fetchDataTransactionForUsd();
    timerForUSD = Timer.periodic(Duration(seconds: timerSecond), (timer) async {
      await fetchDataTransactionForUsd();
      if (_previousGechoUsdCoins.data != null &&
          _lastGechoUsdCoins.data != null) {
        if (_previousGechoUsdCoins.data!.isNotEmpty &&
            _lastGechoUsdCoins.data!.isNotEmpty) {
          lastPriceControl(
              _previousGechoUsdCoins.data!, _lastGechoUsdCoins.data!);
        }
        transferLastListToPreviousList(
            _previousGechoUsdCoins.data!, _lastGechoUsdCoins.data!);
      }
    });
  }

  Future<void> fetchGechoBtcCoinListEveryTwoSecond() async {
    await fetchDataTransactionForBtc();
    timerForBTC = Timer.periodic(Duration(seconds: timerSecond), (timer) async {
      await fetchDataTransactionForBtc();
      if (_previousGechoBtcCoins.data != null &&
          _lastGechoBtcCoins.data != null) {
        if (_previousGechoBtcCoins.data!.isNotEmpty &&
            _lastGechoBtcCoins.data!.isNotEmpty) {
          lastPriceControl(
              _previousGechoBtcCoins.data!, _lastGechoBtcCoins.data!);
        }
        transferLastListToPreviousList(
            _previousGechoBtcCoins.data!, _lastGechoBtcCoins.data!);
      }
    });
  }

  Future<void> fetchGechoTryCoinListEveryTwoSecond() async {
    await fetchDataTransactionForTry();
    timerForTRY = Timer.periodic(Duration(seconds: timerSecond), (timer) async {
      await fetchDataTransactionForTry();
      if (_previousGechoTryCoins.data != null &&
          _lastGechoTryCoins.data != null) {
        if (_previousGechoTryCoins.data!.isNotEmpty &&
            _lastGechoTryCoins.data!.isNotEmpty) {
          lastPriceControl(
              _previousGechoTryCoins.data!, _lastGechoTryCoins.data!);
        }
        transferLastListToPreviousList(
            _previousGechoTryCoins.data!, _lastGechoTryCoins.data!);
      }
    });
  }

  Future<void> fetchGechoEthCoinListEveryTwoSecond() async {
    await fetchDataTransactionForEth();
    timerForETH = Timer.periodic(Duration(seconds: timerSecond), (timer) async {
      await fetchDataTransactionForEth();
      if (_previousGechoEthCoins.data != null &&
          _lastGechoEthCoins.data != null) {
        if (_previousGechoEthCoins.data!.isNotEmpty &&
            _lastGechoEthCoins.data!.isNotEmpty) {
          lastPriceControl(
              _previousGechoEthCoins.data!, _lastGechoEthCoins.data!);
        }
        transferLastListToPreviousList(
            _previousGechoEthCoins.data!, _lastGechoEthCoins.data!);
      }
    });
  }

  Future<void> fetchDataTransactionForUsd() async {
    ResponseModel<List<MainCurrencyModel>> responseUSD =
        await getFromCurrencyConverter(CoinCurrency.USD.name);

    if (responseUSD.error != null) {
      responseUSD = ResponseModel<List<MainCurrencyModel>>(
          data: _lastGechoUsdCoins.data, error: responseUSD.error);
    } else if (responseUSD.data != null) {
      _lastGechoUsdCoins = responseUSD;
    } else {
      responseUSD =
          ResponseModel<List<MainCurrencyModel>>(data: _lastGechoUsdCoins.data);
    }
  }

  Future<void> fetchNewGechoUsdCoinListTransactionForUsd() async {
    coinsToBeAdded = _listCoinIdCacheManager.getAllItems() ?? [];
    if (coinsToBeAdded.isNotEmpty) {
      //bunu diğerlerine yaparsan ve isnot empty olayının elsenii yazmasan 404 olayını çözebilirsin
      ResponseModel<List<MainCurrencyModel>> responseNEW =
          await getFromCurrencyConverter(CoinCurrency.USD.name,
              idList: coinsToBeAdded);
      if (responseNEW.error != null) {
        responseNEW = ResponseModel<List<MainCurrencyModel>>(
            data: _lastNewGechoUsdCoins.data, error: responseNEW.error);
      } else if (responseNEW.data != null) {
        _lastNewGechoUsdCoins = responseNEW;
      } else {
        _lastNewGechoUsdCoins = ResponseModel<List<MainCurrencyModel>>(
            data: _lastNewGechoUsdCoins.data);
      }
    } else {
      _lastNewGechoUsdCoins.data?.clear();
    }
  }

  Future<ResponseModel<MainCurrencyModel>> fetchDataById(String id) async {
    ResponseModel<MainCurrencyModel> responseUSD = await CurrencyConverter
        .instance
        .convertGechoCoinListByCurrencyToMyCoinId(id);
    if (responseUSD.error != null) {
      responseUSD = ResponseModel<MainCurrencyModel>(
          data: responseUSD.data, error: responseUSD.error);
    } else if (responseUSD.data != null) {
      responseUSD = responseUSD;
    }
    return responseUSD;
  }

  Future<void> fetchDataTransactionForTry() async {
    ResponseModel<List<MainCurrencyModel>> responseTRY =
        await getFromCurrencyConverter(CoinCurrency.TRY.name);
    if (responseTRY.error != null) {
      responseTRY = ResponseModel<List<MainCurrencyModel>>(
          data: _lastGechoTryCoins.data, error: responseTRY.error);
    } else if (responseTRY.data != null) {
      _lastGechoTryCoins = responseTRY;
    } else {
      responseTRY = ResponseModel<List<MainCurrencyModel>>(
        data: _lastGechoTryCoins.data,
      );
    }
  }

  Future<void> fetchDataTransactionForBtc() async {
    ResponseModel<List<MainCurrencyModel>> responseBTC =
        await getFromCurrencyConverter(CoinCurrency.BTC.name);

    if (responseBTC.error != null) {
      responseBTC = ResponseModel<List<MainCurrencyModel>>(
          data: _lastGechoBtcCoins.data, error: responseBTC.error);
    } else if (responseBTC.data != null) {
      _lastGechoBtcCoins = responseBTC;
    } else {
      responseBTC =
          ResponseModel<List<MainCurrencyModel>>(data: _lastGechoBtcCoins.data);
    }
  }

  Future<void> fetchDataTransactionForEth() async {
    ResponseModel<List<MainCurrencyModel>> responseETH =
        await getFromCurrencyConverter(CoinCurrency.ETH.name);
    if (responseETH.error != null) {
      responseETH = ResponseModel<List<MainCurrencyModel>>(
          data: _lastGechoEthCoins.data, error: responseETH.error);
    } else if (responseETH.data != null) {
      _lastGechoEthCoins = responseETH;
    } else {
      _lastGechoEthCoins =
          ResponseModel<List<MainCurrencyModel>>(data: _lastGechoEthCoins.data);
    }
  }
  /*Future<void> fetchNewGechoUsdCoinListEveryTwoSecond() async {
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
