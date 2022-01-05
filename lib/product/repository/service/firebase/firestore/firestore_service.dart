import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coin_with_architecture/product/repository/service/firebase/firestore/base/store_base.dart';

import '../../../../model/user/my_user_model.dart';

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
  Future<MyUser> readUser(String email) async {
    DocumentSnapshot _user =
        await _firestore.collection("users").doc(email).get();
    if (_user.data() is Map) {} // altakini bunun içine al

    Map<String, dynamic> _userMap = (_user.data() as Map<String, dynamic>);

    MyUser _okunanUserNesnesi = MyUser.fromJson(_userMap);
    return _okunanUserNesnesi;
  }

  @override
  Future<bool> saveUser(MyUser user) async {
    DocumentSnapshot _user =
        await FirebaseFirestore.instance.doc("users/${user.email}").get();

    if (_user.data() == null) {
      //burda userın update olma durumunu ekle sen farkloı bir db kontrolü yapacaksın

      print("nullll");
      print(_user.toString());
      await _firestore.collection("users").doc(user.email).set(user.toMap());
      return true;
    } else {
      return true;
    }
  }
}
