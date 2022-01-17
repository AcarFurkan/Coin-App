import '../constant/app/regex_constants.dart';
import 'package:easy_localization/src/public_ext.dart';

extension StringExtension on String {
  String get locale => this.tr(); // may it be without this?
  bool get isValidEmail => this != null
      ? RegExp(RegexConstants.instance.emailRegex).hasMatch(this)
      : false;
  bool get isValidPassword => this != null
      ? RegExp(RegexConstants.instance.passwordRegex).hasMatch(this)
      : false;
}
