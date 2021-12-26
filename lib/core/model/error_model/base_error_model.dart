import 'package:coin_with_architecture/core/model/error_model/IError_model.dart';

class BaseError extends IErrorModel {
  final String message;
  BaseError(this.message);
}
