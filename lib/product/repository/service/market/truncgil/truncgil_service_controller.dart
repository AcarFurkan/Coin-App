import 'dart:async';
import '../../../../../core/model/response_model/IResponse_model.dart';
import '../../../../../core/enums/price_control.dart';
import '../../../../../core/model/response_model/response_model.dart';
import '../../../../model/my_coin_model.dart';
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
    fetchDataTrasaction();
    timer = Timer.periodic(Duration(seconds: timerSecond), (timer) async {
      fetchDataTrasaction();
      if (_previousTruncgilList.data!.isNotEmpty &&
          _lastTruncgilList.data!.isNotEmpty) {
        lastPriceControl(_previousTruncgilList.data!, _lastTruncgilList.data!);
      }
      transferLastListToPreviousList(
          _previousTruncgilList.data!, _lastTruncgilList.data!);
    });
  }

  Future<void> fetchDataTrasaction() async {
    ResponseModel<List<MainCurrencyModel>> response = await CurrencyConverter
        .instance
        .convertTruncgilListToMyMainCurrencyList();

    if (response.error != null) {
      _lastTruncgilList = response;
    } else if (response.data != null) {
      _lastTruncgilList = response;
      percentageControl(_lastTruncgilList.data!);
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
