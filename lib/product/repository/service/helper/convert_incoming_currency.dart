import 'package:coin_with_architecture/core/enums/price_control.dart';
import 'package:coin_with_architecture/core/model/response_model/response_model.dart';
import 'package:coin_with_architecture/product/model/my_coin_model.dart';
import 'package:coin_with_architecture/product/repository/service/bitexen/bitexen_service.dart';
import 'package:coin_with_architecture/product/repository/service/genelpara/genelpara_service.dart';
import 'package:coin_with_architecture/product/repository/service/hurriyet/hurriyet_service.dart';
import 'package:coin_with_architecture/product/repository/service/truncgil/truncgil_service.dart';
import 'package:coin_with_architecture/product/response_models/bitexen/bitexen_response_model.dart';
import 'package:coin_with_architecture/product/response_models/gecho/gecho_service_model.dart';
import 'package:coin_with_architecture/product/response_models/genelpara/genelpara_service_model.dart';
import 'package:coin_with_architecture/product/response_models/hurriyet/hurriyet_response_model.dart';
import 'package:coin_with_architecture/product/response_models/truncgil/truncgil_response_model.dart';
import 'package:easy_localization/easy_localization.dart';

import '../bitexen/bitexen_service.dart';
import '../gecho/gecho_service.dart';

class CurrencyConverter {
  static CurrencyConverter? _instance;
  static CurrencyConverter get instance {
    _instance ??= CurrencyConverter._init();
    return _instance!;
  }

  CurrencyConverter._init();

  Future<ResponseModel<MainCurrencyModel>> convertBitexenCoinToMyCoin(
      String name) async {
    var response = await BitexenService.instance.getCoinByName(name);
    Bitexen? bitexenCoin = response.data;
    MainCurrencyModel? myCoin;
    if (bitexenCoin != null) {
      myCoin = mainCurrencyGeneratorFromBitexenModel(bitexenCoin);
    }
    return ResponseModel<MainCurrencyModel>(
        data: myCoin, error: response.error);
  }

  Future<ResponseModel<List<MainCurrencyModel>>>
      convertBitexenListCoinToMyCoinList() async {
    var response = await BitexenService.instance.getAllCoins();
    List<Bitexen>? bitexenCoinList = response.data;
    List<MainCurrencyModel>? myCoin;

    if (bitexenCoinList != null) {
      myCoin = bitexenCoinList
          .map((e) => mainCurrencyGeneratorFromBitexenModel(e))
          .toList();
    }
    return ResponseModel<List<MainCurrencyModel>>(
        data: myCoin, error: response.error);
  }

  Future<ResponseModel<List<MainCurrencyModel>>>
      convertGenelParaStockListToMyMainCurrencyList() async {
    var response = await GenelParaService.instance.getAllGenelParaStocksList();

    List<GenelPara>? genelParaStocksList = response.data;
    List<MainCurrencyModel>? myCoin;

    if (genelParaStocksList != null) {
      myCoin = genelParaStocksList
          .map((e) => mainCurrencyGeneratorFromGenelParaStockModel(e))
          .toList();
    }
    return ResponseModel<List<MainCurrencyModel>>(
        data: myCoin, error: response.error);
  }

  MainCurrencyModel mainCurrencyGeneratorFromGenelParaStockModel(GenelPara e) {
    return MainCurrencyModel(
      counterCurrencyCode: "TRY",
      name: e.id ?? "",
      lastPrice: (e.alis ?? 0).toString(),
      id: (e.id != null ? e.id! + "genelPara" + "TRY" : ""),
      changeOf24H: (e.degisim ?? 0).toString(),
    );
  }

  Future<ResponseModel<List<MainCurrencyModel>>>
      convertHurriyetStockListToMyMainCurrencyList() async {
    var response = await HurriyetService.instance.getAllHurriyetStocks();

    List<Hurriyet>? hurriyetStocksList = response.data;
    List<MainCurrencyModel>? myCoin;

    if (hurriyetStocksList != null) {
      myCoin = hurriyetStocksList
          .map((e) => mainCurrencyGeneratorFromHurriyetStockModel(e))
          .toList();
    }
    return ResponseModel<List<MainCurrencyModel>>(
        data: myCoin, error: response.error);
  }

  MainCurrencyModel mainCurrencyGeneratorFromHurriyetStockModel(Hurriyet e) {
    return MainCurrencyModel(
        counterCurrencyCode: "TRY",
        name: e.sembol ?? "",
        lastPrice: (e.alis ?? 0).toString(),
        id: (e.sembol != null ? e.sembol! + "hurriyet" + "TRY" : ""),
        changeOf24H: (e.yuzdedegisim ?? 0).toString(),
        lowOf24h: (e.dusuk ?? 0).toString(),
        highOf24h: (e.yuksek ?? 0).toString(),
        lastUpdate: DateFormat.jms().format(e.tarih!));
  }

  Future<ResponseModel<List<MainCurrencyModel>>>
      convertTruncgilListToMyMainCurrencyList() async {
    var response = await TruncgilService.instance.getAllTruncgil();
    List<Truncgil>? truncgilCoinList = response.data;
    List<MainCurrencyModel>? myCoin;

    if (truncgilCoinList != null) {
      myCoin = truncgilCoinList
          .map((e) => mainCurrencyGeneratorFromTrungilModel(e))
          .toList();
    }
    return ResponseModel<List<MainCurrencyModel>>(
        data: myCoin, error: response.error);
  }

  Future<ResponseModel<List<MainCurrencyModel>>>
      convertGechoCoinListToMyCoinList() async {
    var response = await GechoService.instance.getAllCoins();
    List<Gecho>? gechoCoinList = response.data;
    List<MainCurrencyModel>? myCoin;
    if (gechoCoinList != null) {
      myCoin = gechoCoinList
          .map((e) => mainCurrencyGeneratorFromGechoModel(e, "USD"))
          .toList();
    }
    return ResponseModel<List<MainCurrencyModel>>(
        data: myCoin, error: response.error);
  }

  Future<ResponseModel<List<MainCurrencyModel>>>
      convertGechoCoinListByCurrencyToMyCoinList(String name) async {
    var response = await GechoService.instance.getAllCoinsByCurrency(name);
    List<Gecho>? gechoCoinList = response.data;
    List<MainCurrencyModel>? myCoin;
    if (gechoCoinList != null) {
      myCoin = gechoCoinList
          .map((e) => mainCurrencyGeneratorFromGechoModel(e, name))
          .toList();
    }
    return ResponseModel<List<MainCurrencyModel>>(
        data: myCoin, error: response.error);
  }

  MainCurrencyModel mainCurrencyGeneratorFromBitexenModel(Bitexen coin) {
    var date = DateTime.fromMillisecondsSinceEpoch(
        (double.parse(coin.timestamp ?? "0") * 1000).round());

    return MainCurrencyModel(
        name: coin.market!.baseCurrencyCode!,
        lastPrice: coin.lastPrice,
        id: coin.market!.baseCurrencyCode! +
            "bitexen" +
            coin.market!.counterCurrencyCode!,
        changeOf24H: coin.change24H,
        counterCurrencyCode: coin.market?.counterCurrencyCode,
        lowOf24h: coin.low24H,
        highOf24h: coin.high24H,
        lastUpdate:
            DateFormat.jms().format(date)); //DateFormat.jms().format(date)
  }

  MainCurrencyModel mainCurrencyGeneratorFromGechoModel(
      Gecho coin, String currecny) {
    String changeOf24Hour =
        percentageCotnrol((coin.priceChangePercentage24H ?? 0).toString());
    var duration = DateTime.now().timeZoneOffset;
    return MainCurrencyModel(
        counterCurrencyCode: currecny,
        name: coin.symbol ?? "",
        lastPrice: (coin.currentPrice ?? 0).toString(),
        id: (coin.id != null ? coin.id! + "gecho" + currecny : ""),
        changeOf24H: (coin.priceChangePercentage24H ?? 0).toString(),
        lowOf24h: (coin.low24H ?? 0).toString(),
        highOf24h: (coin.high24H ?? 0).toString(),
        lastUpdate: DateFormat.jms().format(
            coin.lastUpdated!.add(Duration(minutes: duration.inMinutes))));
  }

  MainCurrencyModel mainCurrencyGeneratorFromTrungilModel(Truncgil e) {
    return MainCurrencyModel(
        name: e.name ?? "",
        lastPrice: e.buy,
        id: e.id ?? "",
        changeOf24H: e.change,
        counterCurrencyCode: "TRY",
        lastUpdate: e.updateDate);
  }

  String percentageCotnrol(String percentage) {
    if (percentage[0] == "-") {
      return PriceLevelControl.DESCREASING.name;
    } else if (double.parse(percentage) > 0) {
      //  L AM NOT SURE FOR THIS TRY IT
      return PriceLevelControl.INCREASING.name;
    } else {
      return PriceLevelControl.CONSTANT.name;
    }
  }
}
