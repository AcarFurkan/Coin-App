import 'package:firebase_core/firebase_core.dart';

class FirebaseCustomExceptions {
  static String convertFirebaseMessage(String exceptionCode) {
    switch (exceptionCode) {
      case 'email-already-in-use':
        return "Bu mail adresi zaten kullanımda, lütfen farklı bir mail kullanınız";
      case 'user-not-found':
        return "Bu kullanıcı sistemde bulunmamaktadır. Lütfen önce oturum açınız";
      case 'too-many-requests':
        return "bi yavaş gardaş";
      case 'wrong-password':
        return "Email veya şifre yanlış";
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