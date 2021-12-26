import 'package:coin_with_architecture/core/enums/http_request_enum.dart';
import 'package:coin_with_architecture/core/model/base_model/base_model.dart';
import 'package:coin_with_architecture/core/model/response_model/IResponse_model.dart';

abstract class ICoreDio {
  Future<IResponseModel<R>> fetchData<R, T extends BaseModel>(String path,
      {required HttpTypes types,
      required T parseModel,
      dynamic data,
      Map<String, Object>? queryParameters,
      void Function(int, int)? onReciveProgress});
}
