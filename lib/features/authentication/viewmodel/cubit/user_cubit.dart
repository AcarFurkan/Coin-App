import 'package:bloc/bloc.dart';
import 'package:coin_with_architecture/product/repository/service/firebase/auth/base/auth_base.dart';
import 'package:meta/meta.dart';

import 'package:coin_with_architecture/product/model/user/my_user_model.dart';
import 'package:coin_with_architecture/product/repository/service/user_service_controller/user_service_controller.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> implements AuthBase {
  UserCubit() : super(UserInitial()) {
    getCurrentUser();
  }

  final UserServiceController _userServiceController =
      UserServiceController.instance;
  MyUser? user;
  String? email;
  String? password;
  String? emailErrorMessage;
  String? passwordErrorMessage;
  //MyUser? get user => _user;
//
  //set user(MyUser? value) => _user = value;

  @override
  Future<MyUser?> createUserWithEmailandPassword(
      String email, String password) async {
    if (true) {
      // email password control
      try {
        emit(UserLoading());
        user = await _userServiceController.createUserWithEmailandPassword(
            email, password);
        if (user != null) {
          emit(UserFull(user: user!));
        }
      } catch (e) {
        emit(UserError());
        print("viewmodel creat user error" + e.toString());
      }
    }
  }

  @override
  Future<MyUser?> getCurrentUser() async {
    try {
      emit(UserLoading());
      user = await _userServiceController.getCurrentUser();
      if (user != null) {
        emit(UserFull(user: user!));
        return user; // YOU ARE YOU SUİNG BLOC YOU DONT NEED NEED RETURN STATEMENT ANYMORE.
      } else {
        emit(UserNull());
      }
    } catch (e) {
      emit(UserError());
      print("Viewmodel current user error" + e.toString());
    }
  }

  @override
  Future<MyUser?> signInWithEmailandPassword(
      String email, String password) async {
    try {
      if (true) {
        // Email Password control
        emit(UserLoading());
        user = await _userServiceController.signInWithEmailandPassword(
            email, password);
        if (user != null) {
          emit(UserFull(user: user!));
        } else {
          emit(UserNull());
        }
      }
    } catch (e) {
      emit(UserError());
      print("viewmodel sign in with email error" + e.toString());
    }
  }

  @override
  Future<MyUser?> signInWithGoogle() async {
    try {
      emit(UserLoading());
      user = await _userServiceController.signInWithGoogle();
      if (user != null) {
        emit(UserFull(user: user!));

        return user; // YOU ARE YOU SUİNG BLOC YOU DONT NEED NEED RETURN STATEMENT ANYMORE.
      } else {
        emit(UserNull());
      }
    } catch (e) {
      emit(UserError());
      print("viewmodel google signin error:" + e.toString());
    }
  }

  @override
  Future<bool> signOut() async {
    try {
      emit(UserLoading());
      bool result = await _userServiceController.signOut();
      user = null;
      emit(UserNull());
      return result;
    } catch (e) {
      print("Viewmodel signout error" + e.toString());
      emit(UserError());
      return false;
    }
  }

  bool _emailPasswordControl(String email, String password) {
    var result = true;
    if (password.length <= 4) {
      passwordErrorMessage = "Password must be at least 4 characters ";
      result = false;
    } else {
      passwordErrorMessage = null;
    }
    if (!email.contains("@")) {
      emailErrorMessage = "invalid email";
      result = false;
    } else {
      emailErrorMessage = null;
    }
    return result;
  }
}
