import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../../../../core/enums/dotenv_enums.dart';
import '../../../../../core/init/network/core_dio.dart';
import '../../../../../core/model/error_model/base_error_model.dart';
import '../../../../../core/model/response_model/IResponse_model.dart';
import '../../../../../core/model/response_model/response_model.dart';
import '../../../../response_models/bitexen/bitexen_response_model.dart';
import '../base_service.dart';

class BitexenService implements BaseRepository<Bitexen> {
  static BitexenService? _instance;
  static BitexenService get instance {
    _instance ??= BitexenService._init();
    return _instance!;
  }

  CoreDio? coreDioForAllCoins;
  CoreDio? coreDioForSingleCoin;

  BitexenService._init() {
    final baseOptions = BaseOptions();
    coreDioForSingleCoin = CoreDio(baseOptions);
    coreDioForAllCoins = CoreDio(baseOptions);
    coreDioForSingleCoin?.interceptors
        .add(InterceptorsWrapper(onResponse: (response, handler) {
      // burdaki responsun yerine baseResponsu koyabilirsin.
      response.data = Bitexen.fromJson(response.data["data"]["ticker"]);

      return handler.next(response);
    }));
    coreDioForAllCoins?.interceptors
        .add(InterceptorsWrapper(onResponse: (response, handler) {
      response.data =
          bitexenFromJson(response.data["data"]["ticker"]).values.toList();
      return handler.next(response);
    }));
  }

  @override
  Future<IResponseModel<List<Bitexen>>> getAllCoins() async {
    var response = await coreDioForAllCoins!
        .get<List<Bitexen>>(dotenv.get(DotEnvEnums.BASE_URL_BITEXEN.name));

    switch (response.statusCode) {
      case HttpStatus.ok:
      case HttpStatus.accepted:
        return ResponseModel<List<Bitexen>>(data: response.data);

      default:
        return ResponseModel<List<Bitexen>>(error: BaseError('message'));
    }
  }

  // burdaki gibi iki farklı intercepterwrapper kullanırsak patlarmıyız.
  @override
  Future<IResponseModel<Bitexen>> getCoinByName(String name) async {
    var response = await coreDioForSingleCoin?.get<Bitexen>(
        dotenv.get(DotEnvEnums.BASE_URL_BITEXEN.name) + "/" + name + "/");
    switch (response?.statusCode) {
      case HttpStatus.ok:
      case HttpStatus.accepted:
        return ResponseModel<Bitexen>(data: response?.data);

      default:
        return ResponseModel<Bitexen>(error: BaseError('message'));
    }
  }
}
