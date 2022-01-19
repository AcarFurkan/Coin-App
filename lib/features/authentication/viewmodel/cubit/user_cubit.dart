import 'package:bloc/bloc.dart';
import 'package:coin_with_architecture/product/model/coin/my_coin_model.dart';
import 'package:flutter/material.dart';

import '../../../../core/enums/back_up_enum.dart';
import '../../../../core/exception/custom_exception_firebase.dart';
import '../../../../locator.dart';
import '../../../../product/model/user/my_user_model.dart';
import '../../../../product/repository/cache/coin_cache_manager.dart';
import '../../../../product/repository/service/user_service_controller/user_service_controller.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
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
  }

  tappedLoginRegisterButton() async {
    changeAutoValidateMode();
    if (formState.currentState!.validate()) {
      if (isLoginPage) {
        await signInWithEmailandPassword(
            emailControllerForLogin!.text, passwordControllerForLogin!.text);
      } else {
        await createUserWithEmailandPassword(emailControllerForRegister!.text,
            passwordControllerForRegister!.text, nameController!.text);
      }
    } else {
      emit(UserNull());
    }
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
    if (BackUpTypes.never.name != groupValue) {
      user?.isBackUpActive = true;
    } else {
      user?.isBackUpActive = false;
    }

    user?.backUpType = groupValue;
    emit(UserFull(user: user!));

    if (user != null) {
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

  Future<void> createUserWithEmailandPassword(
      String email, String password, String name) async {
    emit(UserLoading());
    var result = await _userServiceController.createUserWithEmailandPassword(
        email, password, name);
    if (result.error != null) {
      user = result.data;
      emit(UserError(message: result.error!.message));
      emit(UserNull());
    } else if (result.data != null) {
      user = result.data;
      emit(UserFull(user: user!));
    } else if (result.data == null) {
      user = result.data;

      emit(UserNull());
    } else {
      user = result.data;

      emit(UserNull());
    }
  }

  Future<void> getCurrentUser() async {
    if (user == null) {
      emit(UserLoading());
    }
    var result = await _userServiceController.getCurrentUser();
    if (result.error != null) {
      user = result.data;

      emit(UserError(message: result.error!.message));
      emit(UserNull());
    } else if (result.data != null) {
      user = result.data;
      emit(UserFull(user: user!));
    } else {
      user = result.data;

      emit(UserNull());
    }
  }

  Future<void> signInWithEmailandPassword(String email, String password) async {
    emit(UserLoading());

    var result = await _userServiceController.signInWithEmailandPassword(
        email, password);
    if (result.error != null) {
      user = result.data;

      emit(UserError(message: result.error!.message));
      emit(UserNull());
    } else if (result.data != null) {
      user = result.data;
      emit(UserFull(user: user!));
    } else {
      user = result.data;

      emit(UserNull());
    }
  }

  //on PlatformException catch (e) {
  //   return ResponseModel<MyUser>(error: BaseError(message: e.toString()));
  // }
  //PlatformException (PlatformException(sign_in_canceled, com.google.android.gms.common.api.ApiException: 12501: , null, null))
  Future<MyUser?> signInWithGoogle() async {
    emit(UserLoading());
    var result = await _userServiceController.signInWithGoogle();
    if (result.error != null) {
      user = result.data;
      emit(UserError(message: "Cancelled"));
      emit(UserNull());
    } else if (result.data != null) {
      user = result.data;
      print("***********************************");

      print(user!.backUpType.toString());
      fetchCurrenciesByEmail(user!);
      emit(UserFull(user: user!));
    } else {
      user = result.data;

      emit(UserNull());
    }
  }

  Future<void> signOut() async {
    emit(UserLoading());
    var result = await _userServiceController.signOut();
    if (result.error != null) {
      user = result.data;
      emit(UserError(message: result.error!.message));
      emit(UserNull());
    }
    user = result.data;
    emit(UserNull());
  }

  void overwriteDataToDb() {
    //  _cacheManager.addItems(differentCurrensies);bunuda bir dene***************************************

    differentCurrensies.forEach((element) {
      _cacheManager.putItem(element.id, element);
    });
  }

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

      emit(UserError(message: "errorMessage"));
      emit(UserNull());
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
