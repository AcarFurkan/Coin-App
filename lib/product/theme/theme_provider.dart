import '../../core/enums/app_theme_enums.dart';
import '../../core/enums/locale_keys_enum.dart';
import '../../locator.dart';
import '../repository/cache/app_cache_manager.dart';
import 'package:flutter/material.dart';

import '../../core/init/theme/app_theme.dart';

class ThemeProvider with ChangeNotifier {
  bool isdark = true;

  ThemeData theme = ThemeManager.craeteTheme(AppThemeDark());
  AppCacheManager? _appCacheManager;
  initilizeCacheManager() {
    _appCacheManager ??= locator<AppCacheManager>();
  }

  getTheme() {
    if (isdark == false) {
      _appCacheManager!
          .putItem(PreferencesKeys.APP_THEME.name, AppTheme.LIGHT.name);
      theme = ThemeManager.craeteTheme(AppThemeLight());

      notifyListeners();
    } else {
      _appCacheManager!
          .putItem(PreferencesKeys.APP_THEME.name, AppTheme.DARK.name);
      theme = ThemeManager.craeteTheme(AppThemeDark());
      notifyListeners();
    }
  }

  setTheme() {}

  getThemeFromLocale() {
    initilizeCacheManager();
    String? localeTheme =
        _appCacheManager!.getItem(PreferencesKeys.APP_THEME.name);
    if ("DARK" == localeTheme) {
      isdark = true;
      theme = ThemeManager.craeteTheme(AppThemeDark());
      notifyListeners();
    } else if ("LIGHT" == localeTheme) {
      isdark = false;

      theme = ThemeManager.craeteTheme(AppThemeLight());
      notifyListeners();
    } else {
      isdark = true;
      theme = ThemeManager.craeteTheme(AppThemeDark());
      notifyListeners();
    }
  }

  changeTheme() {
    isdark = !isdark;
    getTheme();
    notifyListeners();
  }
}
