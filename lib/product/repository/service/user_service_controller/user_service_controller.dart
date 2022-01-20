import 'package:coin_with_architecture/product/model/coin/my_coin_model.dart';

import '../../../../core/enums/back_up_enum.dart';
import '../../../../core/model/response_model/IResponse_model.dart';

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

  Future<IResponseModel<MyUser?>> getCurrentUser() async {
    IResponseModel<MyUser?> response =
        await _firebaseAuthService.getCurrentUser();
    if (response.data != null) {
      return await _firestoreService
          .readUserInformations(response.data!.email ?? "");
    }
    return response;
  }

  Future<IResponseModel<MyUser?>> createUserWithEmailandPassword(
      String email, String password, String name) async {
    IResponseModel<MyUser?> response = await _firebaseAuthService
        .createUserWithEmailandPassword(email, password, name);
    if (response.error != null) {
      return response;
    } else if (response.data != null) {
      response.data!.backUpType = BackUpTypes.never.name;
      response.data!.isBackUpActive = false;
      response.data!.name = name;
      return await _firestoreService.saveUserInformations(response.data!);
    }
    return response;
  }

  Future<IResponseModel<MyUser?>> signInWithEmailandPassword(
      String email, String password) async {
    IResponseModel<MyUser?> response =
        await _firebaseAuthService.signInWithEmailandPassword(email, password);

    if (response.error != null) {
      return response;
    } else if (response.data != null) {
      IResponseModel<MyUser?> responseModel = await _firestoreService
          .readUserInformations(response.data!.email ?? "");
      MyUser? userFromService = responseModel.data;
      if (userFromService != null) {
        response =
            await _firestoreService.saveUserInformations(userFromService);
      }
      return response;
    }
    return response;
  }

  Future<IResponseModel<MyUser?>> signInWithGoogle() async {
    IResponseModel<MyUser?> response =
        await _firebaseAuthService.signInWithGoogle();
    if (response.error != null) {
      return response;
    } else if (response.data != null) {
      List<MainCurrencyModel>? coins = _fetchAllAddedCoinsFromDatabase();
      IResponseModel<MyUser?> responseModel = await _firestoreService
          .readUserInformations(response.data!.email ?? "");
      MyUser? userFromService = responseModel.data;
      if (userFromService == null) {
        response.data!.backUpType = BackUpTypes.never.name;
        response.data!.isBackUpActive = false;
        response.data!.name = response.data!.email!.split("@")[0];
        return await _firestoreService.saveUserInformations(
          response.data!,
        );
      } else {
        return responseModel;
      }
    }
    return response;
  }

  Future<IResponseModel<MyUser>> signOut() async {
    return await _firebaseAuthService.signOut();
  }

  Future<IResponseModel<MyUser?>> updateUser(MyUser user) async {
    return await _firestoreService.updateUserInformations(user);
  }

  Future<IResponseModel<MyUser?>> updateUserCurrenciesInformation(
      MyUser user, // burda user dönmeyi düşünebilirsin
      {List<MainCurrencyModel>? listCurrency}) async {
    return await _firestoreService.updateUserCurrenciesInformation(user,
        listCurrencyFromDb: listCurrency);
  }

  Future<IResponseModel<List<MainCurrencyModel>?>> fetchCoinInfoByEmail(
      String email) async {
    return await _firestoreService.fetchCurrenciesByEmail(email);
  }

  final CoinCacheManager _cacheManager = locator<CoinCacheManager>();
  List<MainCurrencyModel>? _fetchAllAddedCoinsFromDatabase() {
    return _cacheManager.getValues();
  }
}
