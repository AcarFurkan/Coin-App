import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../../../../core/enums/dotenv_enums.dart';
import '../../../../../core/init/network/core_dio.dart';
import '../../../../../core/model/error_model/base_error_model.dart';
import '../../../../../core/model/response_model/IResponse_model.dart';
import '../../../../../core/model/response_model/response_model.dart';
import '../../../../response_models/genelpara/genelpara_service_model.dart';

class GenelParaService {
  static GenelParaService? _instance;
  static GenelParaService get instance {
    _instance ??= GenelParaService._init();
    return _instance!;
  }

  CoreDio? coreDio;

  GenelParaService._init() {
    coreDio = CoreDio(BaseOptions());

    coreDio?.interceptors.add(InterceptorsWrapper(
      onResponse: (response, handler) {
        List keys = [];
        List<GenelPara> genelParaList = [];
        response.data = jsonDecode(response.data);
        print(response.data.runtimeType);
        if (response.data is Map) {
          keys = (response.data as Map).keys.toList();
          for (var i = 0; i < keys.length; i++) {
            genelParaList.add(
                GenelPara.fromJson((response.data as Map).values.toList()[i]));
            genelParaList[i].id = keys[i];
            genelParaList[i].degisim =
                genelParaList[i].degisim?.replaceAll(",", ".");
          }
        }
        response.data = genelParaList;
        return handler.next(response);
      },
    ));
  }

  @override
  Future<IResponseModel<List<GenelPara>>> getAllGenelParaStocksList() async {
    var response = await coreDio!.get<List<GenelPara>>(
        dotenv.get(DotEnvEnums.BASE_URL_STOCK_MARKET_GENELPARA.name));
    switch (response.statusCode) {
      case HttpStatus.ok:
      case HttpStatus.accepted:
        return ResponseModel<List<GenelPara>>(data: response.data);

      default:
        return ResponseModel<List<GenelPara>>(error: BaseError('message'));
    }
  }
}
