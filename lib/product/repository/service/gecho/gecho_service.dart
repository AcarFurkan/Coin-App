import 'package:coin_with_architecture/core/enums/dotenv_enums.dart';
import 'package:coin_with_architecture/core/enums/http_request_enum.dart';
import 'package:coin_with_architecture/core/init/network/core_dio.dart';
import 'package:coin_with_architecture/core/model/response_model/IResponse_model.dart';
import 'package:coin_with_architecture/product/repository/service/base_service.dart';
import 'package:coin_with_architecture/product/response_models/gecho/gecho_service_model.dart';
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

  Future<IResponseModel<List<Gecho>>> getAllCoinsByCurrency(
      String currency) async {
    return await coreDio!.fetchData<List<Gecho>, Gecho>(
        "coins/markets?vs_currency=$currency&order=market_cap_desc&per_page=250&page=1&sparkline=false",
        types: HttpTypes.GET,
        parseModel: Gecho());
  }

  @override
  Future<IResponseModel<Gecho>> getCoinByName(String name) {
    // TODO: implement getCoinByName
    throw UnimplementedError();
  }
}
