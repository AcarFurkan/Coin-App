import '../../../features/coin/add_coin_page/view/add_coin_page.dart';
import '../../../features/coin/search_coin_page/view/search_page.dart';
import '../../model/coin/my_coin_model.dart';

import '../../../features/authentication/user_settings/view/user_settings_page.dart';
import '../../../features/home/landing_page.dart/landing_page.dart';
import '../../../features/home/landing_page.dart/splash_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../features/coin/coin_detail_page/view/coin_detail_page.dart';
import '../../../features/home/home_view.dart';
import '../../../features/settings/view/settings_page.dart';

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
        return _routeOlustur(FutureBuilderForIsFirstOpen(), settings);
      case '/home':
        return _routeOlustur(const HomeView(), settings);
      case '/userSettings':
        return _routeOlustur(UserSettings(), settings);
      case '/splash':
        return _routeOlustur(const Splash(), settings);

      case '/settingsGeneral':
        return _routeOlustur(const SettingsPage(), settings);
      case '/searchPage':
        return _routeOlustur(const SearchPage(), settings);
      case '/addCoinPage':
        return _routeOlustur(const AddCoinPage(), settings);

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
