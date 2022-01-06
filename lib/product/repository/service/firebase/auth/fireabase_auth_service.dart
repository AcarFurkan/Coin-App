import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../../model/user/my_user_model.dart';
import 'base/auth_base.dart';

class FirebaseAuthService implements AuthBase {
  static FirebaseAuthService? _instace;
  static FirebaseAuthService get instance {
    _instace ??= FirebaseAuthService._init();
    return _instace!;
  }

  FirebaseAuthService._init() {
    _auth = FirebaseAuth.instance;
  }

  late final FirebaseAuth _auth;
  @override
  Future<MyUser?> createUserWithEmailandPassword(
      String email, String password, String name) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      return _userFromFirebase(userCredential.user);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Future<MyUser?> getCurrentUser() {
    try {
      User? user = _auth.currentUser;
      return Future.value(_userFromFirebase(user));
    } catch (e) {
      print("current user error" + e.toString());
      return Future.value(null);
    }
  }

  @override
  Future<MyUser?> signInWithEmailandPassword(
      String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      if (userCredential.user != null) {}
      return _userFromFirebase(userCredential.user);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }

  MyUser? _userFromFirebase(User? user) {
    if (user == null) {
      return null;
    } else {
      return MyUser(email: user.email, name: user.uid);
    }
  }

  @override
  Future<MyUser?> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);
    return _userFromFirebase(userCredential.user);
  }

  @override
  Future<bool> signOut() async {
    try {
      final _googleSignIn = GoogleSignIn();
      await _googleSignIn.signOut();

      await _auth.signOut();
      return true;
    } catch (e) {
      print("sign out error:" + e.toString());
      return false;
    }
  }
}
