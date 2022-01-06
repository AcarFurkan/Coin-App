import 'package:coin_with_architecture/features/authentication/login/view/login_page_two.dart';
import 'package:coin_with_architecture/features/home/landing_page.dart/landing_page.dart';
import 'package:coin_with_architecture/features/home/landing_page.dart/splash_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../features/authentication/authentication_welcome/view/authentication_welcome_page.dart';
import '../../../features/authentication/login/view/login_page.dart';
import '../../../features/authentication/register/view/register_page.dart';
import '../../../features/coin/coin_detail_page/view/coin_detail_page.dart';
import '../../../features/home/home_view.dart';
import '../../../features/settings/view/settings_page.dart';
import '../../model/my_coin_model.dart';

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
        return _routeOlustur(const HomeView(), settings);
      case '/login':
        return _routeOlustur(LoginPage(), settings);
      case '/splash':
        return _routeOlustur(const Splash(), settings);
      case '/register':
        return _routeOlustur(const RegisterPage(), settings);
      case '/settingsGeneral':
        return _routeOlustur(const SettingsPage(), settings);
      case '/userSettings':
        return _routeOlustur(const AuthWelcomePage(), settings);
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
              title: const Text('404'),
            ),
            body: const Center(
              child: Text('Sayfa Bulunamadı'),
            ),
          ),
        );
    }
  }
}
