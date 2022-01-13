import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../../../product/model/user/my_user_model.dart';
import '../../../../enums/fireauth_request_enum.dart';
import '../../../../exception/custom_exception_firebase.dart';
import '../../../../model/error_model/base_error_model.dart';
import '../../../../model/firebase/firebase_auth_request_model.dart';
import '../../../../model/response_model/IResponse_model.dart';
import '../../../../model/response_model/response_model.dart';
import 'IFirebase_auth.dart';

class FirebaseAuthCustom implements IFirebaseAuth {
  @override
  Future<IResponseModel<MyUser>> get(
      {required FirebaseAuthTypes type,
      required FirebaseAuth auth,
      FirebaseAuthRequestModel? requestModel}) async {
    try {
      switch (type) {
        case FirebaseAuthTypes.login:
          UserCredential userCredential = await auth.signInWithEmailAndPassword(
              email: requestModel!.email, password: requestModel.password);
          final response = _userFromFirebase(userCredential.user);
          return ResponseModel<MyUser>(data: response);
        case FirebaseAuthTypes.register:
          UserCredential userCredential =
              await auth.createUserWithEmailAndPassword(
                  email: requestModel!.email, password: requestModel.password);
          final response = _userFromFirebase(userCredential.user);
          return ResponseModel<MyUser>(data: response);
        case FirebaseAuthTypes.currentUser:
          return ResponseModel<MyUser>(
              data: _userFromFirebase(auth.currentUser));
        case FirebaseAuthTypes.google:
          var result = await signInWithGoogle();
          return ResponseModel<MyUser>(data: _userFromFirebase(result));
        case FirebaseAuthTypes.signOut:
          await signOut(auth);
          return ResponseModel<MyUser>();
      }
    } on FirebaseAuthException catch (e) {
      String message = FirebaseCustomExceptions.convertFirebaseMessage(e.code);
      return ResponseModel<MyUser>(error: BaseError(message: message));
    } catch (e) {
      return ResponseModel<MyUser>(error: BaseError(message: e.toString()));
    }
  }

  Future<User?> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);
    return userCredential.user;
  }

  Future<bool> signOut(FirebaseAuth auth) async {
    final _googleSignIn = GoogleSignIn();
    await _googleSignIn.signOut();

    await auth.signOut();
    return true;
  }

  MyUser? _userFromFirebase(User? user) {
    if (user == null) {
      return null;
    } else {
      return MyUser(email: user.email);
    }
  }
}
