import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coin_with_architecture/core/model/error_model/base_error_model.dart';
import 'package:coin_with_architecture/core/model/response_model/IResponse_model.dart';
import 'package:coin_with_architecture/core/model/response_model/response_model.dart';
import 'package:coin_with_architecture/product/model/coin/my_coin_model.dart';

import '../../../../model/user/my_user_model.dart';
import 'base/store_base.dart';

class FirestoreService implements StoreBase {
  static FirestoreService? _instace;
  static FirestoreService get instance {
    _instace ??= FirestoreService._init();
    return _instace!;
  }

  late final FirebaseFirestore _firestore;

  FirestoreService._init() {
    _firestore = FirebaseFirestore.instance;
  }

  @override
  Future<IResponseModel<List<MainCurrencyModel>?>> fetchCurrenciesByEmail(
      String email) async {
    List<MainCurrencyModel>?
        listMainCurrency; //burda colectionref in için boşsa listmain currenct eski datayı dönebilir
    try {
      QuerySnapshot collectionref = await _firestore
          .collection("users")
          .doc(email)
          .collection("currency")
          .get();

      if (collectionref.docs.isNotEmpty) {
        listMainCurrency = collectionref.docs
            .map((e) =>
                MainCurrencyModel.fromJson((e.data() as Map<String, dynamic>)))
            .toList();
      }
      return ResponseModel(data: listMainCurrency);
    } catch (e) {
      return ResponseModel(error: BaseError(message: e.toString()));
    }
  }

  @override
  Future<ResponseModel<MyUser?>> readUserInformations(String email) async {
    DocumentSnapshot _user =
        await _firestore.collection("users").doc(email).get();
    if (_user.data() is Map) {} // altakini bunun içine al
    Map<String, dynamic> _userMap;
    MyUser? userFromMap;
    if (_user.data() != null) {
      _userMap = (_user.data() as Map<String, dynamic>);
      userFromMap = MyUser.fromJson(_userMap);
      if (_userMap["updatedAt"] != null) {
        userFromMap.updatedAt = DateTime.fromMillisecondsSinceEpoch(
          (_userMap["updatedAt"] as Timestamp).millisecondsSinceEpoch,
        ).toLocal();
      }
    }
    return ResponseModel(data: userFromMap);
  }

  @override
  Future<IResponseModel<MyUser?>> saveUserInformations(MyUser user,
      {List<MainCurrencyModel>? listCurrency}) async {
    try {
      var map = user.toJson();

      if (user.updatedAt == null) {
        user.level = 1;

        map["updatedAt"] = FieldValue.serverTimestamp();
      } else {
        map["updatedAt"] = Timestamp.fromMillisecondsSinceEpoch(
            user.updatedAt!.millisecondsSinceEpoch);
      }

      await _firestore.collection("users").doc(user.email).set(map);
      if (listCurrency != null && listCurrency.isNotEmpty) {
        for (var item in listCurrency) {
          await _firestore
              .collection("users")
              .doc(user.email)
              .collection("currency")
              .doc(item.id)
              .set(item.toMap());
        }
      }
      IResponseModel responseModel =
          await readUserInformations(user.email!); //Todo
      MyUser? myUser = responseModel.data;
      return ResponseModel(data: myUser);
    } catch (e) {
      return ResponseModel(error: BaseError(message: e.toString()));
    }
  }

  @override
  Future<MyUser?> updateUserCurrenciesInformation(MyUser user,
      {List<MainCurrencyModel>? listCurrencyFromDb}) async {
    DocumentSnapshot _user = await _firestore.doc("users/${user.email}").get();
    var map = user.toJson();
    map["updatedAt"] = FieldValue.serverTimestamp();

    await _firestore.collection("users").doc(user.email).set(map);
    if (listCurrencyFromDb != null) {
      IResponseModel<List<MainCurrencyModel>?> responseModel =
          await fetchCurrenciesByEmail(user.email!);

      List<MainCurrencyModel>? listFromService = responseModel.data;

      print(listFromService?.length);

      if (listFromService != null) {
        for (var item in listCurrencyFromDb) {
          await _firestore
              .collection("users")
              .doc(user.email)
              .collection("currency")
              .doc(item.id)
              .set(item.toMap());
        }

        for (var item in listFromService) {
          if (!listCurrencyFromDb.contains(item)) {
            await _firestore
                .collection("users")
                .doc(user.email)
                .collection("currency")
                .doc(item.id)
                .delete();
          }
        }
      } else {
        for (var item in listCurrencyFromDb) {
          await _firestore
              .collection("users")
              .doc(user.email)
              .collection("currency")
              .doc(item.id)
              .set(item.toMap());
        }
      }
    }
    IResponseModel responseModel =
        await readUserInformations(user.email!); //Todo
    MyUser? myUser = responseModel.data;

    return myUser;
  }

  @override
  Future<bool> updateUserInformations(MyUser user,
      {List<MainCurrencyModel>? listCurrency}) async {
    var map = user.toJson();

    if (user.updatedAt == null) {
      map["updatedAt"] = FieldValue.serverTimestamp();
    } else {
      map["updatedAt"] = Timestamp.fromMillisecondsSinceEpoch(
          user.updatedAt!.millisecondsSinceEpoch);
    }

    await _firestore.collection("users").doc(user.email).set(map);

    return true;
  }
}
