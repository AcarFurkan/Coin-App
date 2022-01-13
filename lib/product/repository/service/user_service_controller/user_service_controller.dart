import '../../../../core/enums/back_up_enum.dart';
import '../../../../core/model/response_model/IResponse_model.dart';

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

  Future<IResponseModel<MyUser>> getCurrentUser() async {
    return await _firebaseAuthService.getCurrentUser();
  }

  final CoinCacheManager _cacheManager = locator<CoinCacheManager>();
  List<MainCurrencyModel>? _fetchAllAddedCoinsFromDatabase() {
    return _cacheManager.getValues();
  }

  Future<IResponseModel<MyUser>> createUserWithEmailandPassword(
      String email, String password, String name) async {
    IResponseModel<MyUser> response = await _firebaseAuthService
        .createUserWithEmailandPassword(email, password, name);
    if (response.error != null) {
      return response;
    } else if (response.data != null) {
      List<MainCurrencyModel>? coins = _fetchAllAddedCoinsFromDatabase();
      if (coins != null) {
        response.data!.backUpType = BackUpTypes.never.name;
        response.data!.isBackUpActive = false;
        response.data!.name = name;
      }
      return response;
    }
    return response;
  }

  Future<IResponseModel<MyUser>> signInWithEmailandPassword(
      String email, String password) async {
    IResponseModel<MyUser> response =
        await _firebaseAuthService.signInWithEmailandPassword(email, password);

    if (response.error != null) {
      return response;
    } else if (response.data != null) {
      MyUser? userFromService = await _firestoreService
          .readUserInformations(response.data!.email ?? "");
      if (userFromService != null) {
        await _firestoreService.saveUserInformations(userFromService);
        response.data = userFromService;
      }
      return response;
    }
    return response;
  }

  Future<IResponseModel<MyUser>> signInWithGoogle() async {
    IResponseModel<MyUser> response =
        await _firebaseAuthService.signInWithGoogle();
    if (response.error != null) {
      return response;
    } else if (response.data != null) {
      List<MainCurrencyModel>? coins = _fetchAllAddedCoinsFromDatabase();

      MyUser? userFromService = await _firestoreService
          .readUserInformations(response.data!.email ?? "");
      if (userFromService == null) {
        response.data!.backUpType = BackUpTypes.never.name;
        response.data!.isBackUpActive = false;
        response.data!.name = response.data!.email!.split("@")[0];
        userFromService =
            await _firestoreService.saveUserInformations(response.data!);
        return response;
      }
      return response;
    }
    return response;
  }

  Future<IResponseModel<MyUser>> signOut() async {
    return await _firebaseAuthService.signOut();
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
}
