import 'package:firebase_auth/firebase_auth.dart';

import '../../../../../product/model/user/my_user_model.dart';
import '../../../../enums/fireauth_request_enum.dart';
import '../../../../model/firebase/firebase_auth_request_model.dart';
import '../../../../model/response_model/IResponse_model.dart';

abstract class IFirebaseAuth {
  Future<IResponseModel<MyUser>> get({
    required FirebaseAuthTypes type,
    required FirebaseAuth auth,
    FirebaseAuthRequestModel? requestModel,
  });
}
