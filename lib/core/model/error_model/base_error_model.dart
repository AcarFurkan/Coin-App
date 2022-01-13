import 'IError_model.dart';

class BaseError extends IErrorModel {
  final String message;

  BaseError({required this.message}) : super(message: message);
}
