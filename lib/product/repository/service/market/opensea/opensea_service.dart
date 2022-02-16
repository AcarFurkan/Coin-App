import 'dart:io';

import 'package:coin_with_architecture/core/init/network/core_dio.dart';
import 'package:coin_with_architecture/core/model/error_model/base_error_model.dart';
import 'package:coin_with_architecture/core/model/response_model/IResponse_model.dart';
import 'package:coin_with_architecture/core/model/response_model/response_model.dart';
import 'package:dio/dio.dart';
import '../../../../response_models/opensea/opensea_response_model.dart';

class OpenSeaService {
  static OpenSeaService? _instance;
  static OpenSeaService get instance {
    _instance ??= OpenSeaService._init();
    return _instance!;
  }

  CoreDio? coreDio;

  OpenSeaService._init() {
    coreDio = CoreDio(BaseOptions());

    coreDio?.interceptors.add(InterceptorsWrapper(
      onResponse: (response, handler) {
        if (response.data is Map) {
          response.data = response.data["collection"]["stats"];
        }
        return handler.next(response);
      },
    ));
  }

  @override
  Future<ResponseModel<OpenSea>> getCollection() async {
    try {
      var response = await coreDio!
          .get("https://api.opensea.io/api/v1/collection/ninja-squad-official");

      switch (response.statusCode) {
        case HttpStatus.ok:
        case HttpStatus.accepted:
          return ResponseModel<OpenSea>(data: OpenSea.fromJson(response.data));

        default:
          return ResponseModel<OpenSea>(
              error: BaseError(message: response.statusCode.toString()));
      }
    } catch (e) {
      return ResponseModel<OpenSea>(error: BaseError(message: e.toString()));
    }
  }
}
