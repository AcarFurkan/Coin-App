import '../../../core/model/response_model/IResponse_model.dart';

abstract class BaseRepository<T> {
  Future<IResponseModel<List<T>>> getAllCoins();
  Future<IResponseModel<T>> getCoinByName(String name);
}
