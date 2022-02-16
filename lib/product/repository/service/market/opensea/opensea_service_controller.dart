import 'dart:async';

import 'package:coin_with_architecture/core/enums/price_control.dart';
import 'package:coin_with_architecture/core/model/response_model/IResponse_model.dart';
import 'package:coin_with_architecture/core/model/response_model/response_model.dart';
import 'package:coin_with_architecture/product/model/coin/my_coin_model.dart';
import 'package:coin_with_architecture/product/repository/service/market/helper/convert_incoming_currency.dart';

class OpenSeaServiceController {
  final int timerSecond = 20;

  static OpenSeaServiceController? _instance;
  static OpenSeaServiceController get instance {
    _instance ??= OpenSeaServiceController._init();
    return _instance!;
  }

  OpenSeaServiceController._init() {
    _previousNftCollections = ResponseModel(data: []);
    _lastNftCollections = ResponseModel(data: []);
  }

  late Timer timer;

  late IResponseModel<List<MainCurrencyModel>> _previousNftCollections;
  late IResponseModel<List<MainCurrencyModel>> _lastNftCollections;
  IResponseModel<List<MainCurrencyModel>> get getCollections =>
      _lastNftCollections;

  Future<void> fetchOpenSeaCollectionEveryTwoSecond() async {
    await fetchDataTrarnsactions();
    timer = Timer.periodic(Duration(seconds: timerSecond), (timer) async {
      await fetchDataTrarnsactions();
      if (_previousNftCollections.data != null &&
          _lastNftCollections.data != null) {
        if (_previousNftCollections.data!.isNotEmpty &&
            _lastNftCollections.data!.isNotEmpty) {
          lastPriceControl(
              _previousNftCollections.data!, _lastNftCollections.data!);
        }
        transferLastListToPreviousList(
            _previousNftCollections.data!, _lastNftCollections.data!);
      }
    });
  }

  Future<void> fetchDataTrarnsactions() async {
    ResponseModel<MainCurrencyModel> response =
        await CurrencyConverter.instance.convertNftCollectionToMainCurrency();
    if (response.error != null) {
      _lastNftCollections = ResponseModel<List<MainCurrencyModel>>(
          data: _lastNftCollections.data, error: response.error);
    } else if (response.data != null) {
      print("data nul değil");
      _lastNftCollections.data?.clear();

      _lastNftCollections.data?.add(response.data!);
      //_lastNftCollections.data![0] = response.data!;
    } else {
      //TODO:BUNU YAPMAMA GEREK VAR MI
      _lastNftCollections = ResponseModel<List<MainCurrencyModel>>(
          data: _lastNftCollections.data);
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
      //TODO: BURDA EĞER İLK 100 COİN DEĞİŞİRSE PATLARSIN HABERİN OLA IDE GORE KONTROL YAP
      List<MainCurrencyModel> previousList,
      List<MainCurrencyModel> lastList) {
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
