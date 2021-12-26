import 'package:flutter/material.dart';

class LanguageManager extends ChangeNotifier {
  static LanguageManager? _instace;
  static LanguageManager get instance {
    _instace ??= LanguageManager._init();
    return _instace!;
  }

  LanguageManager._init();

  final enLocal = const Locale('en', 'US');
  final trLocal = const Locale('tr', 'TR');
  final krLocal = const Locale('ko', 'KO');
  final gbLocal = const Locale('en', 'GB');
  final arLocal = const Locale('ar', 'DZ');
  List<Locale> get supportedLocales =>
      [enLocal, gbLocal, trLocal, krLocal, arLocal];
}
