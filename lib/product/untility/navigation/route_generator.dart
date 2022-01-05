import 'package:coin_with_architecture/features/authentication/authentication_welcome/view/authentication_welcome_page.dart';
import 'package:coin_with_architecture/features/authentication/login/view/login_page.dart';
import 'package:coin_with_architecture/features/authentication/register/view/register_page.dart';
import 'package:coin_with_architecture/features/coin/coin_detail_page/view/coin_detail_page.dart';
import 'package:coin_with_architecture/features/home/home_view.dart';
import 'package:coin_with_architecture/features/settings/view/settings_page.dart';
import 'package:coin_with_architecture/product/model/my_coin_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../main.dart';

class RouteGenerator {
  static Route<dynamic>? _routeOlustur(
      Widget gidilecekWidget, RouteSettings settings) {
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return CupertinoPageRoute(
        settings: settings,
        builder: (context) => gidilecekWidget,
      );
    } else if (defaultTargetPlatform == TargetPlatform.android) {
      return MaterialPageRoute(
        settings: settings,
        builder: (context) => gidilecekWidget,
      );
    } else {
      return CupertinoPageRoute(
        settings: settings,
        builder: (context) => gidilecekWidget,
      );
    }
  }

  static Route<dynamic>? routeGenerator(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return _routeOlustur(TrialSomething(), settings);
      case '/home':
        return _routeOlustur(HomeView(), settings);
      case '/login':
        return _routeOlustur(LoginPage(), settings);
      case '/splash':
        return _routeOlustur(Splash(), settings);
      case '/register':
        return _routeOlustur(RegisterPage(), settings);
      case '/settingsGeneral':
        return _routeOlustur(SettingsPage(), settings);
      case '/userSettings':
        return _routeOlustur(AuthWelcomePage(), settings);
      case '/detailPage':
        var arg = settings.arguments as MainCurrencyModel;

        return _routeOlustur(
            CoinDetailPage(
              coin: arg,
            ),
            settings);

      default:
        return MaterialPageRoute(
          builder: (context) => Scaffold(
            appBar: AppBar(
              title: Text('404'),
            ),
            body: const Center(
              child: Text('Sayfa Bulunamadı'),
            ),
          ),
        );
    }
  }
}
