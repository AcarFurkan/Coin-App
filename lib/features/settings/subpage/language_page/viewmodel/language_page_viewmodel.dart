import '../../../../../core/extension/string_extension.dart';
import '../../../model/language_model.dart';
import '../../../../../product/language/language_manager.dart';
import '../../../../../product/language/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flag/flag.dart';
import 'package:flutter/cupertino.dart';

class LanguageViewModel extends ChangeNotifier {
  late List<LanguageModel> langModel;
  BuildContext context;
  LanguageViewModel({
    required this.context,
  }) {
    //getCurrentLanguage();
    //notifyListeners();
  }

  getCurrentLanguage() {
    langModel = context.supportedLocales.map((e) {
      if (e.countryCode == "KO") {
        return LanguageModel(
            flag: Flag.fromCode(FlagsCode.KR),
            name: LocaleKeys.changeLanguagePage_korean.locale,
            code: e.countryCode!);
      } else if (e.countryCode == "US") {
        return LanguageModel(
            flag: Flag.fromCode(FlagsCode.US),
            name: LocaleKeys.changeLanguagePage_englishUS.locale,
            code: e.countryCode!);
      } else if (e.countryCode == "GB") {
        return LanguageModel(
            flag: Flag.fromCode(FlagsCode.GB),
            name: LocaleKeys.changeLanguagePage_englishUK.locale,
            code: e.countryCode!);
      } else if (e.countryCode == "TR") {
        return LanguageModel(
            flag: Flag.fromCode(FlagsCode.TR),
            name: LocaleKeys.changeLanguagePage_turkish.locale,
            code: e.countryCode!);
      } else if (e.countryCode == "DZ") {
        return LanguageModel(
            flag: Flag.fromCode(FlagsCode.DZ),
            name: LocaleKeys.changeLanguagePage_arabic.locale,
            code: e.countryCode!);
      }
      return LanguageModel(
          flag: Flag.fromString(e.countryCode!),
          name: "name",
          code: e.countryCode!);
    }).toList();
  }

  setLanguage(String countryCode) {
    if (countryCode == "KO") {
      context.setLocale(LanguageManager.instance.krLocal);
    } else if (countryCode == "US") {
      context.setLocale(LanguageManager.instance.enLocal);
    } else if (countryCode == "GB") {
      context.setLocale(LanguageManager.instance.gbLocal);
    } else if (countryCode == "TR") {
      context.setLocale(LanguageManager.instance.trLocal);
    } else if (countryCode == "DZ") {
      context.setLocale(LanguageManager.instance.arLocal);
    }
  }
}
