import '../../../../../core/enums/dotenv_enums.dart';
import '../../../../../core/enums/http_request_enum.dart';
import '../../../../../core/init/network/core_dio.dart';
import '../../../../../core/model/response_model/IResponse_model.dart';
import '../../../../response_models/gecho/gecho_service_model.dart';

import '../base_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

enum Currencies { USD, BTC, ETH, TRY }

class GechoService implements BaseRepository<Gecho> {
  static GechoService? _instance;

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
        "coins/markets?vs_currency=usd&order=market_cap_desc&per_page=250&page=1&sparkline=false",
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
      print(idUrl);
    }
    return await coreDio!.fetchData<List<Gecho>, Gecho>(
        "coins/markets?vs_currency=$currency$idUrl&order=market_cap_desc&per_page=250&page=1&sparkline=false",
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
}
