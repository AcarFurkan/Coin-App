import '../../../../../../core/model/response_model/IResponse_model.dart';
import '../../../../../model/user/my_user_model.dart';

abstract class AuthBase {
  Future<IResponseModel<MyUser>> getCurrentUser();
  Future<IResponseModel<MyUser>> signOut();
  Future<IResponseModel<MyUser>> signInWithGoogle();
  Future<IResponseModel<MyUser>> signInWithEmailandPassword(
      String email, String sifre);
  Future<IResponseModel<MyUser>> createUserWithEmailandPassword(
      String email, String sifre, String name);
}
