import 'package:coin_with_architecture/core/model/error_model/IError_model.dart';

abstract class IResponseModel<T> {
  T? data;
  IErrorModel? error;
}
