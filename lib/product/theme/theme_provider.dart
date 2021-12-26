import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../core/init/theme/app_theme.dart';

class ThemeProvider extends ChangeNotifier {
  bool isdark = false;

  ThemeData theme = ThemeManager.craeteTheme(AppThemeLight());

  getTheme() {
    if (isdark == false) {
      theme = ThemeManager.craeteTheme(AppThemeLight());
      notifyListeners();
    } else {
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
