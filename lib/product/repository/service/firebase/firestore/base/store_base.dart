import '../../../../../model/my_coin_model.dart';
import '../../../../../model/user/my_user_model.dart';

abstract class StoreBase {
  Future<MyUser?> saveUserInformations(MyUser user,
      {List<MainCurrencyModel> listCurrency});
  Future<MyUser?> readUserInformations(String email);
  Future<List<MainCurrencyModel>?> fetchCurrenciesByEmail(String email);
}
