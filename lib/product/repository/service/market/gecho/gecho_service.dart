import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../../../../core/enums/dotenv_enums.dart';
import '../../../../../core/enums/http_request_enum.dart';
import '../../../../../core/init/network/core_dio.dart';
import '../../../../../core/model/response_model/IResponse_model.dart';
import '../../../../response_models/gecho/gecho_service_model.dart';
import '../base_service.dart';

class GechoService implements BaseRepository<Gecho> {
  static GechoService? _instance;
  Timer? _timer;

  static GechoService get instance {
    _instance ??= GechoService._init();
    return _instance!;
  }

  CoreDio? coreDio;

  GechoService._init() {
    final baseOptions =
        BaseOptions(baseUrl: dotenv.get(DotEnvEnums.BASE_URL_COIN_GECHO.name));
    coreDio = CoreDio(baseOptions);
  }

  @override
  Future<IResponseModel<List<Gecho>>> getAllCoins() async {
    return await coreDio!.fetchData<List<Gecho>, Gecho>(
        "coins/markets?vs_currency=usd&order=market_cap_desc&per_page=100&page=1&sparkline=false",
        types: HttpTypes.GET,
        parseModel: Gecho());
  }

  //https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&ids=bitcoin
  Future<IResponseModel<List<Gecho>>> getCoinsById(String id) async {
    return await coreDio!.fetchData<List<Gecho>, Gecho>(
        "coins/markets?vs_currency=usd&ids=$id",
        types: HttpTypes.GET,
        parseModel: Gecho());
  }

  Future<IResponseModel<List<Gecho>>> getAllCoinsByCurrency(String currency,
      {List<String>? idList}) async {
    String idUrl = "";
    if (idList != null) {
      idUrl = "&ids=";
      for (var i = 0; i < idList.length; i++) {
        idUrl += idList[i];
        if (idList.last != idList[i]) {
          idUrl += "%2C";
        }
      }
    }
    return await coreDio!.fetchData<List<Gecho>, Gecho>(
        "coins/markets?vs_currency=$currency$idUrl&order=market_cap_desc&per_page=100&page=1&sparkline=false",
        types: HttpTypes.GET,
        parseModel: Gecho());
  }
  //coins/markets?vs_currency=usd&ids=ninja-squad%2Ctalecraft&order=market_cap_desc&per_page=100&page=1&sparkline=false
  //coins/markets?vs_currency=usd&ids=ninja-squad%2Ctalecraft%2Cbitcoin&order=market_cap_desc&per_page=100&page=1&sparkline=false
//  /////////////////////////////&ids=ninja-squad%2talecraft%2bitcoin

  @override
  Future<IResponseModel<Gecho>> getCoinByName(String name) {
    // TODO: implement getCoinByName
    throw UnimplementedError();
  }

  Future getAllCoinsIdList() async {
    CoreDio coreDioForList = CoreDio(BaseOptions());

    var response = await coreDioForList
        .get("https://api.coingecko.com/api/v3/coins/list/");

    switch (response.statusCode) {
      case 200:
        Map<String, Map> mapId = {};
        //GechoAllIdList.fromJson(item);
        for (var item in (response.data as List)) {
          mapId[('${item["id"] ?? ""}')] = {
            "id": ('${item["id"] ?? ""}'),
            "symbol": ('${item["symbol"] ?? ""}'),
            "name": ('${item["name"] ?? ""}')
          };
        }

        return mapId;
      default:
        print("DEFAULT");
        return {};
    }
  }
}
/**
 * Future getAllCoinsIdList() async {
    CoreDio coreDioForList = CoreDio(BaseOptions());
    print("object");

    var response = await coreDioForList
        .get("https://api.coingecko.com/api/v3/coins/list/");

    switch (response.statusCode) {
      case 200:
        print((response.data as List).length);
        Map<String, Map> mapId = {};
        print("*********" * 10);
        //GechoAllIdList.fromJson(item);
        for (var item in (response.data as List)) {
          mapId[('\'${item["id"] ?? ""}\'')] = {
            "'id'": ('\'${item["id"] ?? ""}\''),
            "'symbol'": ('\'${item["symbol"] ?? ""}\''),
            "'name'": ('\'${item["name"] ?? ""}\'')
          };
        }
   
        print("-------------------------------------------------");
        //// print(mapId);
        print(mapId.keys.length);

       
        return mapId;
        break;
      default:
        print("DEFAULT");
    }
  }
 */