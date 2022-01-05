import '../../../../../model/user/my_user_model.dart';

abstract class StoreBase {
  Future<bool> saveUser(MyUser user);
  Future<MyUser> readUser(String email);
}
