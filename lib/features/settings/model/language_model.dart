import 'package:flag/flag.dart';

class LanguageModel {
  Flag flag;
  String name;
  String code;
  bool isActive;
  LanguageModel({
    required this.flag,
    required this.name,
    required this.code,
    this.isActive = false,
  });
}
