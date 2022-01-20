import 'package:coin_with_architecture/core/extension/string_extension.dart';
import 'package:coin_with_architecture/product/language/locale_keys.g.dart';

class FirebaseCustomExceptions {
  static String convertFirebaseMessage(String exceptionCode) {
    switch (exceptionCode) {
      case 'email-already-in-use':
        return LocaleKeys.exceptionMessages_emailAlreadyExist.locale;
      case 'user-not-found':
        return LocaleKeys.exceptionMessages_userNotFound.locale;
      case 'too-many-requests':
        return LocaleKeys.exceptionMessages_tooManyRequest.locale;
      case 'wrong-password':
        return LocaleKeys.exceptionMessages_wrongPassword.locale;
      default:
        return exceptionCode;
    }
  }
}

 

/*
 if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }*/

      /**
       * if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
       * 
       */