import 'package:bloc/bloc.dart';
import 'package:coin_with_architecture/core/enums/back_up_enum.dart';
import 'package:flutter/material.dart';
import '../../../../product/repository/cache/coin_cache_manager.dart';
import '../../../../locator.dart';
import '../../../../product/model/my_coin_model.dart';
import '../../../../product/repository/service/firebase/auth/base/auth_base.dart';

import '../../../../product/model/user/my_user_model.dart';
import '../../../../product/repository/service/user_service_controller/user_service_controller.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> implements AuthBase {
  UserCubit() : super(UserInitial()) {
    getCurrentUser();
    groupValue = BackUpTypes.never.name;
    isLoginPage = true;
    isLockOpen = true;
    autoValidateMode = AutovalidateMode.disabled;
    tabbarIndex = 0;
  }

  final UserServiceController _userServiceController =
      UserServiceController.instance;
  MyUser? user;
  String? email;
  late bool isLoginPage;
  late bool isLockOpen;

  String? password;
  String? emailErrorMessage;
  String? passwordErrorMessage;
  bool? isBackUpActiveForUpdate;
  String? backUpTypeForUpdate;
  List<MainCurrencyModel> differentCurrensies = [];
  List<MainCurrencyModel>? coinListFromDataBase;
  TextEditingController? emailControllerForLogin = TextEditingController();
  TextEditingController? passwordControllerForLogin = TextEditingController();
  TextEditingController? emailControllerForRegister = TextEditingController();
  TextEditingController? passwordControllerForRegister =
      TextEditingController();
  late int tabbarIndex;
  TextEditingController? nameController = TextEditingController();
  late AutovalidateMode autoValidateMode;
  final GlobalKey<FormState> formState = GlobalKey<FormState>();

  final CoinCacheManager _cacheManager = locator<CoinCacheManager>();
  late String groupValue;
  changeGroupValue(String path) {
    groupValue = path;
    emit(UserFull(user: user!));
  }

  changeAutoValidateMode() {
    autoValidateMode = AutovalidateMode.always;

    //if (autoValidateMode == AutovalidateMode.disabled) {
    //} else {
    //  autoValidateMode = AutovalidateMode.disabled;
    //}
  }

  tappedLoginRegisterButton() async {
    changeAutoValidateMode();
    print("object");
    print(formState.currentState!.validate());
    emit(UserNull());

    // if (isLoginPage) {
    //   await signInWithEmailandPassword(
    //       emailController!.text, passwordController!.text);
    // } else {
    //   await createUserWithEmailandPassword(emailController!.text,
    //       passwordController!.text, nameController!.text);
    // }
  }

  changeIsLoginPage(int index) {
    if (index == 0) {
      tabbarIndex = 0;
      isLoginPage = true;
    } else {
      tabbarIndex = 1;

      isLoginPage = false;
    }
    emit(UserNull());
  }

  changeIsLockOpen() {
    isLockOpen = !isLockOpen;
    emit(UserNull());
  }

  Future<MyUser?> updateUser() async {
    print(groupValue == BackUpTypes.tapped.name);
    if (BackUpTypes.never.name != groupValue) {
      user?.isBackUpActive = true;
    } else {
      user?.isBackUpActive = false;
    }

    user?.backUpType = groupValue;
    emit(UserFull(user: user!));

    if (user != null) {
      //user = await _userServiceController.updateUser(user!);
      try {
        print(user?.updatedAt);
        user = await _userServiceController.updateUser(user!);
      } catch (e) {
        print("viewmodel creat updateUser" + e.toString());
      }
    }
  }

  List<MainCurrencyModel>? _fetchAllAddedCoinsFromDatabase() {
    print(_cacheManager.getValues()?.length);
    return _cacheManager.getValues();
  }

  @override
  Future<MyUser?> createUserWithEmailandPassword(
      String email, String password, String name) async {
    if (true) {
      // email password control
      try {
        emit(UserLoading());
        user = await _userServiceController.createUserWithEmailandPassword(
            email, password, name);
        if (user != null) {
          emit(UserFull(user: user!));
        } else {
          emit(UserNull());
        }
      } catch (e) {
        print("viewmodel creat user error" + e.toString());

        emit(UserError());
        emit(UserNull());
      }
    }
  }

  @override
  Future<MyUser?> getCurrentUser() async {
    try {
      if (user == null) {
        emit(UserLoading());
      }

      user = await _userServiceController.getCurrentUser();
      if (user != null) {
        emit(UserFull(user: user!));

        return user; // YOU ARE YOU SUİNG BLOC YOU DONT NEED NEED RETURN STATEMENT ANYMORE.
      } else {
        emit(UserNull());
      }
    } catch (e) {
      print("Viewmodel current user error" + e.toString());

      emit(UserError());
      emit(UserNull());
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
          fetchCurrenciesByEmail(user!);
          emit(UserFull(user: user!));
        } else {
          emit(UserNull());
        }
      }
    } catch (e) {
      print("viewmodel sign in with email error" + e.toString());

      emit(UserError());
      emit(UserNull());
    }
  }

  void overwriteDataToDb() {
    //  _cacheManager.addItems(differentCurrensies);bunuda bir dene***************************************

    differentCurrensies.forEach((element) {
      _cacheManager.putItem(element.id, element);
    });
  }

  @override
  Future<List<MainCurrencyModel>?> fetchCurrenciesByEmail(MyUser user) async {
    differentCurrensies.clear();
    List<MainCurrencyModel>? listCurrenciesFromService;
    List<MainCurrencyModel>? listCurrenciesFromDb;

    try {
      if (true) {
        listCurrenciesFromService =
            await _userServiceController.fetchCoinInfoByEmail(user.email ?? "");
        listCurrenciesFromDb = _fetchAllAddedCoinsFromDatabase();

        if (listCurrenciesFromService != null) {
          if (listCurrenciesFromDb != null) {
            // db de dont send null list it send empty list
            // DB BOŞ OLABİLİR BUNU DEĞİŞTİR
            for (var itemFromService in listCurrenciesFromService) {
              if (!(listCurrenciesFromDb.contains(itemFromService))) {
                differentCurrensies.add(itemFromService);
              }
            }
            if (differentCurrensies.isNotEmpty) {
              emit(UserUpdate());
              emit(UserFull(user: user));
            }
          }
        }
        return listCurrenciesFromService;
      }
    } catch (e) {
      print("viewmodel fetch currencies error" + e.toString());

      emit(UserError());
      emit(UserNull());
    }
  }

  @override
  Future<MyUser?> signInWithGoogle() async {
    try {
      emit(UserLoading());
      user = await _userServiceController.signInWithGoogle();
      if (user != null) {
        fetchCurrenciesByEmail(user!);
        emit(UserFull(user: user!));

        return user; // YOU ARE YOU SUİNG BLOC YOU DONT NEED NEED RETURN STATEMENT ANYMORE.
      } else {
        emit(UserNull());
      }
    } catch (e) {
      print("viewmodel google signin error:" + e.toString());

      emit(UserError());
      emit(UserNull());
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
      emit(UserNull());

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

  Future<void> backUpWhenTapped() async {
    List<MainCurrencyModel>? mainCurrencyList =
        _fetchAllAddedCoinsFromDatabase();

    await _userServiceController.updateUserCurrenciesInformation(user!,
        listCurrency: mainCurrencyList);
    await getCurrentUser();
  }
}
