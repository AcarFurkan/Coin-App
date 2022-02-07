import 'dart:async';
import '../../../../model/coin/my_coin_model.dart';

import '../../../../../core/model/response_model/IResponse_model.dart';
import '../../../../../core/enums/price_control.dart';
import '../../../../../core/model/response_model/response_model.dart';
import '../helper/convert_incoming_currency.dart';

class TruncgilServiceController {
  final int timerSecond = 5;

  static TruncgilServiceController? _instance;
  static TruncgilServiceController get instance {
    _instance ??= TruncgilServiceController._init();
    return _instance!;
  }

  TruncgilServiceController._init() {
    _previousTruncgilList = ResponseModel(data: []);
    _lastTruncgilList = ResponseModel(data: []);
  }

  late Timer timer;

  late IResponseModel<List<MainCurrencyModel>> _previousTruncgilList;
  late IResponseModel<List<MainCurrencyModel>> _lastTruncgilList;
  IResponseModel<List<MainCurrencyModel>> get getTruncgilList =>
      _lastTruncgilList;

  Future<void> fetchTruncgilListEveryTwoSecond() async {
    await fetchDataTrasaction();
    timer = Timer.periodic(Duration(seconds: timerSecond), (timer) async {
      await fetchDataTrasaction();
      if (_previousTruncgilList.data != null &&
          _lastTruncgilList.data != null) {
        if (_previousTruncgilList.data!.isNotEmpty &&
            _lastTruncgilList.data!.isNotEmpty) {
          lastPriceControl(
              _previousTruncgilList.data!, _lastTruncgilList.data!);
        }
        transferLastListToPreviousList(
            _previousTruncgilList.data!, _lastTruncgilList.data!);
      }
    });
  }

  Future<void> fetchDataTrasaction() async {
    ResponseModel<List<MainCurrencyModel>> response = await CurrencyConverter
        .instance
        .convertTruncgilListToMyMainCurrencyList();
    if (response.error != null) {
      _lastTruncgilList = ResponseModel<List<MainCurrencyModel>>(
          data: _lastTruncgilList.data, error: response.error);
    } else if (response.data != null) {
      _lastTruncgilList = response;
    } else {
      _lastTruncgilList =
          ResponseModel<List<MainCurrencyModel>>(data: _lastTruncgilList.data);
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
