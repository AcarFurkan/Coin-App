import '../error_model/IError_model.dart';

abstract class IResponseModel<T> {
  T? data;
  IErrorModel? error;
}
