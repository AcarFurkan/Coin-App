import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:get/get_connect/http/src/status/http_status.dart';

import '../../enums/http_request_enum.dart';
import '../../extension/network_type_extension.dart';
import '../../model/base_model/base_model.dart';
import '../../model/error_model/base_error_model.dart';
import '../../model/response_model/IResponse_model.dart';
import '../../model/response_model/response_model.dart';
import 'ICore_dio.dart';

class CoreDio with DioMixin implements Dio, ICoreDio {
  @override
  final BaseOptions options;

  CoreDio(this.options) {
    options = options;
    interceptors.add(InterceptorsWrapper());
    httpClientAdapter = DefaultHttpClientAdapter();
  }

  @override
  Future<IResponseModel<R>> fetchData<R, T extends BaseModel>(String path,
      {required HttpTypes types,
      required T parseModel,
      dynamic data,
      Map<String, Object>? queryParameters,
      void Function(int, int)? onReciveProgress}) async {
    try {
      final response = await request(path,
          data: data, options: Options(method: types.rawValue));
      switch (response.statusCode) {
        case HttpStatus.ok:
        case HttpStatus.accepted:
          final model = _responseParser<R, T>(parseModel, response.data);

          return ResponseModel<R>(data: model);

        default:
          return ResponseModel<R>(error: BaseError('message'));
      }
    } catch (e) {
      print(e);

      return ResponseModel<R>(error: BaseError('message'));
    }
  }

  R? _responseParser<R, T>(BaseModel model, dynamic data) {
    if (data is List) {
      return data.map((e) => model.fromJson(e)).toList().cast<T>()
          as R; //cast<T> ???
    } else if (data is Map) {
      model.fromJson(data as Map<String, Object>) as R;
    }
    return data as R?;
  }
}
