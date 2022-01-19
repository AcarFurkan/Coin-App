import 'package:coin_with_architecture/core/model/response_model/IResponse_model.dart';
import 'package:coin_with_architecture/product/model/coin/my_coin_model.dart';

import '../../../../../model/user/my_user_model.dart';

abstract class StoreBase {
  Future<IResponseModel<MyUser?>> saveUserInformations(MyUser user,
      {List<MainCurrencyModel> listCurrency});
  Future<IResponseModel<MyUser?>> readUserInformations(String email);
  Future<IResponseModel<List<MainCurrencyModel>?>> fetchCurrenciesByEmail(
      String email);
}
