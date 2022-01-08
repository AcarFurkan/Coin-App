import 'package:coin_with_architecture/core/enums/back_up_enum.dart';

import '../../../model/my_coin_model.dart';
import '../../../model/user/my_user_model.dart';
import '../../cache/coin_cache_manager.dart';
import '../firebase/auth/fireabase_auth_service.dart';
import '../firebase/firestore/firestore_service.dart';

import '../../../../locator.dart';

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

  Future<MyUser?> getCurrentUser() async {
    MyUser? _user = await _firebaseAuthService.getCurrentUser();
    if (_user != null) {
      return await _firestoreService.readUserInformations(_user.email ?? "");
    }
  }

  final CoinCacheManager _cacheManager = locator<CoinCacheManager>();
  List<MainCurrencyModel>? _fetchAllAddedCoinsFromDatabase() {
    return _cacheManager.getValues();
  }

  Future<MyUser?> createUserWithEmailandPassword(
      String email, String password, String name) async {
    MyUser? _user = await _firebaseAuthService.createUserWithEmailandPassword(
        email, password, name);
    if (_user != null) {
      List<MainCurrencyModel>? coins = _fetchAllAddedCoinsFromDatabase();
      if (coins != null) {
        _user.backUpType = BackUpTypes.never.name;
        _user.isBackUpActive = false;
        _user.name = name;
      }

      bool _sonuc = await _firestoreService.saveUserInformations(_user,
          listCurrency: coins);
      if (_sonuc) {
        return await _firestoreService
            .readUserInformations(_user.email ?? ""); // BUNA GEREK YOK
      }
    }
  }

  Future<MyUser?> updateUser(MyUser user) async {
    await _firestoreService.updateUserInformations(user);
    MyUser? myUser = await _firestoreService.readUserInformations(user.email!);
    if (myUser != null) {
      return myUser;
    }
  }

  Future<MyUser?> updateUserCurrenciesInformation(
      MyUser user, // burda user dönmeyi düşünebilirsin

      {List<MainCurrencyModel>? listCurrency}) async {
    try {
      await _firestoreService.updateUserCurrenciesInformation(user,
          listCurrencyFromDb: listCurrency);
    } catch (e) {
      print("user serwvice controller updateuser hata" + e.toString());
    }
  }

  Future<List<MainCurrencyModel>?> fetchCoinInfoByEmail(String email) async {
    List<MainCurrencyModel>? currenciesList =
        await _firestoreService.fetchCurrenciesByEmail(email);
    return currenciesList;
  }

  Future<MyUser?> signInWithEmailandPassword(
      String email, String password) async {
    MyUser? _user =
        await _firebaseAuthService.signInWithEmailandPassword(email, password);
    if (_user != null) {
      MyUser? userFromService =
          await _firestoreService.readUserInformations(_user.email ?? "");

      if (userFromService != null) {
        await _firestoreService.saveUserInformations(userFromService);
      }
      return userFromService;
    }
  }

  Future<MyUser?> signInWithGoogle() async {
    MyUser? _user = await _firebaseAuthService.signInWithGoogle();
    if (_user != null) {
      List<MainCurrencyModel>? coins = _fetchAllAddedCoinsFromDatabase();

      MyUser? userFromService =
          await _firestoreService.readUserInformations(_user.email ?? "");
      if (userFromService != null) {
      } else {
        _user.backUpType = BackUpTypes.never.name;
        _user.isBackUpActive = false;
        await _firestoreService.saveUserInformations(_user);
      }

      return userFromService;
    }
  }

  Future<bool> signOut() async {
    return await _firebaseAuthService.signOut();
  }
}
