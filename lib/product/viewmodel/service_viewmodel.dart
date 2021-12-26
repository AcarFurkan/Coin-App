import 'dart:async';
import 'dart:io';

import '../../core/enums/price_control.dart';

import '../model/my_coin_model.dart';
import '../repository/service/coin_repository.dart';

class ServiceViewModel {
  final BaseRepository _baseRepository;

  ServiceViewModel(this._baseRepository);

  late List<MyCoin> _lastCoinList;

  late List<MyCoin> singleCoinList = [];
  // get getCoinList => _lastCoinList; //// CHANGE THİS

  late Timer timer;
  late double ethusdt;
  late double usdtTry = 1;
  late double btcusdt;
  //late double busdTry;
  //List<MyCoin> allCoins = [];
  List<MyCoin> _previousTryCoins = [];
  List<MyCoin> _lastTryCoins = [];
  get getTryCoinList => _lastTryCoins;

  List<MyCoin> _previousBtcCoins = [];
  List<MyCoin> _lastBtcCoins = [];
  get getBtcCoinList => _lastBtcCoins;

  List<MyCoin> _previousEthCoins = [];
  List<MyCoin> _lastEthCoins = [];
  get getEthCoinList => _lastEthCoins;

  List<MyCoin> _previousUsdtCoins = [];
  List<MyCoin> _lastUsdtCoins = [];
  get getUsdtCoinList => _lastUsdtCoins;

  List<MyCoin> _previousGechoUsdtCoins = [];
  List<MyCoin> _lastGechoUsdtCoins = [];
  get getGechoUsdtCoinList => _lastGechoUsdtCoins;

  void updateDb() {}

  Future<void> fetchCoinListEveryTwoSecond() async {
    var aa = await _baseRepository.getAllCoins();

    _lastCoinList = ((aa).isEmpty == true ? _lastCoinList : aa);
    _lastGechoUsdtCoins =
        await _baseRepository.getCoinAllCoinListFromCoinGecko();

    generateTryCoins(); // bütün coinler try şeklinde geldi ve dolu
    _lastCoinList = await percentageControl(_lastCoinList);

    await convertTryToUsdt();

    convertUsdtToEth();

    convertUsdtToBtc();

    timer = Timer.periodic(const Duration(milliseconds: 2000), (timer) async {
      _lastGechoUsdtCoins =
          await _baseRepository.getCoinAllCoinListFromCoinGecko();

      var aa = await _baseRepository.getAllCoins();
      _lastCoinList = ((aa).isEmpty == true ? _lastCoinList : aa);

      generateTryCoins();
      if (_previousTryCoins.isEmpty != true) {
        lastPriceControl(_previousTryCoins, _lastTryCoins);
      }
      if (_previousGechoUsdtCoins.isEmpty != true) {
        lastPriceControl(_previousGechoUsdtCoins, _lastGechoUsdtCoins);
      }

      _lastCoinList = await percentageControl(_lastCoinList);

      convertTryToUsdt();

      convertUsdtToEth();

      convertUsdtToBtc();

      transferLastListToPreviousList(_previousTryCoins, _lastTryCoins);
      transferLastListToPreviousList(_previousUsdtCoins, _lastUsdtCoins);
      transferLastListToPreviousList(_previousEthCoins, _lastEthCoins);
      transferLastListToPreviousList(_previousBtcCoins, _lastBtcCoins);
      transferLastListToPreviousList(
          _previousGechoUsdtCoins, _lastGechoUsdtCoins);
    });
  }

  transferLastListToPreviousList(
      List<MyCoin> previousList, List<MyCoin> lastList) {
    previousList.clear();
    for (var item in lastList) {
      previousList.add(item);
    }
  }

  Future<void> convertTryToUsdt() async {
    _lastUsdtCoins.clear();

    for (var item in _lastTryCoins) {
      String price = ((double.parse(item.lastPrice!)) / usdtTry).toString();
      String lowOf24h = ((double.parse(item.lowOf24h!)) / usdtTry).toString();
      String highOf24h = ((double.parse(item.highOf24h!)) / usdtTry).toString();
      if (item.id != "USDTTRY") {
        _lastUsdtCoins.add(MyCoin(
          name: item.name,
          lastPrice: price,
          id: item.name + "USDT",
          counterCurrencyCode: "USDT",
          changeOf24H: item.changeOf24H,
          lowOf24h: lowOf24h,
          highOf24h: highOf24h,
          percentageControl: item.percentageControl,
          priceControl: item.priceControl,
        ));
      }
      if (item.id == "ETHTRY") {
        ethusdt = double.parse(price);
      }
      if (item.id == "BTCTRY") {
        btcusdt = double.parse(price);
      }
    }
  }

  void convertUsdtToBtc() {
    _lastBtcCoins.clear();

    for (var item in _lastUsdtCoins) {
      String price =
          ((double.parse(item.lastPrice ?? "0")) / btcusdt).toString();
      String lowOf24h =
          ((double.parse(item.lowOf24h ?? "0")) / btcusdt).toString();
      String highOf24h =
          ((double.parse(item.highOf24h ?? "0")) / btcusdt).toString();

      if (item.id != "BTCUSDT") {
        _lastBtcCoins.add(MyCoin(
          name: item.name,
          lastPrice: price,
          id: item.name + "BTC",
          counterCurrencyCode: "BTC",
          changeOf24H: item.changeOf24H,
          lowOf24h: lowOf24h,
          highOf24h: highOf24h,
          percentageControl: item.percentageControl,
          priceControl: item.priceControl,
        ));
      }
    }
  }

  void convertUsdtToEth() {
    _lastEthCoins.clear();
    for (var item in _lastUsdtCoins) {
      // BURDA USDT DEN Mİ TRY DEN Mİ GEÇMEK DAHA DOĞRU OLUR BİLEMEDİM DOLARDAN DİĞER COİNLERE CEVİREREK YAPACAĞIM
      String price =
          ((double.parse(item.lastPrice ?? "0")) / ethusdt).toString();
      String lowOf24h =
          ((double.parse(item.lowOf24h ?? "0")) / ethusdt).toString();
      String highOf24h =
          ((double.parse(item.highOf24h ?? "0")) / ethusdt).toString();

      if (item.id != "ETHUSDT") {
        //btcusdt/ethusdt == btceth

        _lastEthCoins.add(MyCoin(
          name: item.name,
          lastPrice: price,
          id: item.name + "ETH",
          counterCurrencyCode: "ETH",
          changeOf24H: item.changeOf24H,
          lowOf24h: lowOf24h,
          highOf24h: highOf24h,
          percentageControl: item.percentageControl,
          priceControl: item.priceControl,
        ));
      }
    }
  }

  generateTryCoins() {
    _lastTryCoins.clear();
    for (var item in _lastCoinList) {
      if (item.counterCurrencyCode == "TRY") {
        _lastTryCoins.add(item);
      }
      if (item.id == "USDTTRY") {
        usdtTry = double.parse(item.lastPrice ?? "0");
      }
    }
  }

  Future<List<MyCoin>> percentageControl(List<MyCoin> coin) async {
    /// 2 liste alsın ve sonuç olarak bir liste dönsün
    ///
    List<MyCoin> compareList = [];
    for (var item in coin) {
      compareList.add(item);
    }

    for (var item in compareList) {
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
    return compareList;
  }

  void lastPriceControl(List<MyCoin> previousList, List<MyCoin> lastList) {
    // bu iki list alsın ve sonuç olarak bir liste dönsün

    for (var i = 0; i < lastList.length; i++) {
      double lastPrice = double.parse(lastList[i].lastPrice!);
      if (previousList.isEmpty) {
        return;
      }
      double previousPrice = double.parse(previousList[i].lastPrice!);

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
