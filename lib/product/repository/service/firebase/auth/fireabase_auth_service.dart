import 'package:firebase_auth/firebase_auth.dart';

import '../../../../../core/enums/fireauth_request_enum.dart';
import '../../../../../core/init/network/firebase/auth/firebase_auth.dart';
import '../../../../../core/model/firebase/firebase_auth_request_model.dart';
import '../../../../../core/model/response_model/IResponse_model.dart';
import '../../../../model/user/my_user_model.dart';
import 'base/auth_base.dart';

class FirebaseAuthService implements AuthBase {
  static FirebaseAuthService? _instace;
  static FirebaseAuthService get instance {
    _instace ??= FirebaseAuthService._init();
    return _instace!;
  }

  late FirebaseAuthCustom firebaseCustom;

  FirebaseAuthService._init() {
    firebaseCustom = FirebaseAuthCustom();
    _auth = FirebaseAuth.instance;
  }

  late final FirebaseAuth _auth;
  @override
  Future<IResponseModel<MyUser>> createUserWithEmailandPassword(
      String email, String password, String name) async {
    return await firebaseCustom.get(
        type: FirebaseAuthTypes.register,
        auth: _auth,
        requestModel:
            FirebaseAuthRequestModel(email: email, password: password));
  }

  @override
  Future<IResponseModel<MyUser>> getCurrentUser() {
    return Future.value(firebaseCustom.get(
      type: FirebaseAuthTypes.currentUser,
      auth: _auth,
    ));
  }

  @override
  Future<IResponseModel<MyUser>> signInWithEmailandPassword(
      String email, String password) async {
    return await firebaseCustom.get(
        type: FirebaseAuthTypes.login,
        auth: _auth,
        requestModel:
            FirebaseAuthRequestModel(email: email, password: password));
  }

  @override
  Future<IResponseModel<MyUser>> signInWithGoogle() async {
    return await firebaseCustom.get(
        type: FirebaseAuthTypes.google, auth: _auth);
  }

  @override
  Future<IResponseModel<MyUser>> signOut() async {
    return await firebaseCustom.get(
        type: FirebaseAuthTypes.signOut, auth: _auth);
  }
}
