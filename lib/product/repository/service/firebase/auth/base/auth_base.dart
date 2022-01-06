import '../../../../../model/user/my_user_model.dart';

abstract class AuthBase {
  Future<MyUser?> getCurrentUser();
  Future<bool> signOut();
  Future<MyUser?> signInWithGoogle();
  Future<MyUser?> signInWithEmailandPassword(String email, String sifre);
  Future<MyUser?> createUserWithEmailandPassword(
      String email, String sifre, String name);
}
