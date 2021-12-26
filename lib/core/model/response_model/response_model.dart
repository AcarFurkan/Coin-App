import 'package:coin_with_architecture/core/model/error_model/IError_model.dart';
import 'package:coin_with_architecture/core/model/response_model/IResponse_model.dart';

class ResponseModel<T> extends IResponseModel<T> {
  @override
  final T? data;
  @override
  final IErrorModel? error;

  ResponseModel({this.data, this.error});
}
