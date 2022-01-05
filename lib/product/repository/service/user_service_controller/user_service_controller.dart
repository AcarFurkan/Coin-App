import 'package:coin_with_architecture/product/model/user/my_user_model.dart';
import 'package:coin_with_architecture/product/repository/service/firebase/auth/base/auth_base.dart';
import 'package:coin_with_architecture/product/repository/service/firebase/auth/fireabase_auth_service.dart';
import 'package:coin_with_architecture/product/repository/service/firebase/firestore/firestore_service.dart';

class UserServiceController {
  // add a base

  static UserServiceController? _instace;
  static UserServiceController get instance {
    _instace ??= UserServiceController._init();
    return _instace!;
  }

  late FirebaseAuthService _firebaseAuthService;
  late FirestoreService _firestoreService;
  UserServiceController._init() {
    _firebaseAuthService = FirebaseAuthService.instance;
    _firestoreService = FirestoreService.instance;
  }

  @override
  Future<MyUser?> getCurrentUser() async {
    MyUser? _user = await _firebaseAuthService.getCurrentUser();
    if (_user != null) {
      return await _firestoreService.readUser(_user.email ?? "");
    }
  }

  @override
  Future<MyUser?> createUserWithEmailandPassword(
      String email, String password) async {
    MyUser? _user = await _firebaseAuthService.createUserWithEmailandPassword(
        email, password);
    if (_user != null) {
      bool _sonuc = await _firestoreService.saveUser(_user);
      if (_sonuc) {
        return await _firestoreService.readUser(_user.email ?? "");
      }
    }
  }

  @override
  Future<MyUser?> signInWithEmailandPassword(
      String email, String password) async {
    MyUser? _user =
        await _firebaseAuthService.signInWithEmailandPassword(email, password);
    if (_user != null) {
      return await _firestoreService.readUser(_user.email ?? "");
    }
  }

  @override
  Future<MyUser?> signInWithGoogle() async {
    MyUser? _user = await _firebaseAuthService.signInWithGoogle();
    if (_user != null) {
      bool _sonuc = await _firestoreService.saveUser(_user);
      if (_sonuc) {
        return await _firestoreService.readUser(_user.email ?? "");
      } else {
        await _firebaseAuthService.signOut();
        return null;
      }
    }
  }

  @override
  Future<bool> signOut() async {
    return await _firebaseAuthService.signOut();
  }
}
