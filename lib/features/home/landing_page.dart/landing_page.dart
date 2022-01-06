import 'dart:io';

import 'package:coin_with_architecture/core/enums/locale_keys_enum.dart';
import 'package:coin_with_architecture/features/authentication/onboard/view/onboard_page.dart';
import 'package:coin_with_architecture/features/coin/bitexen/viewmodel/cubit/bitexen_cubit.dart';
import 'package:coin_with_architecture/features/coin/hurriyet/viewmodel/cubit/hurriyet_cubit.dart';
import 'package:coin_with_architecture/features/coin/list_all_coin_page/viewmodel/cubit/coin_list_cubit.dart';
import 'package:coin_with_architecture/features/coin/selected_coin/viewmodel/cubit/coin_cubit.dart';
import 'package:coin_with_architecture/features/coin/truncgil/viewmodel/cubit/truncgil_cubit.dart';
import 'package:coin_with_architecture/product/repository/cache/app_cache_manager.dart';
import 'package:coin_with_architecture/product/repository/cache/coin_cache_manager.dart';
import 'package:coin_with_architecture/product/repository/service/market/bitexen/bitexen_service_controller.dart';
import 'package:coin_with_architecture/product/repository/service/market/gecho/gecho_service_controller.dart';
import 'package:coin_with_architecture/product/repository/service/market/genelpara/genepara_service_controller.dart';
import 'package:coin_with_architecture/product/repository/service/market/truncgil/truncgil_service_controller.dart';
import 'package:coin_with_architecture/product/theme/theme_provider.dart';
import 'package:coin_with_architecture/product/untility/navigation/route_generator.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/src/provider.dart';
import 'package:libwinmedia/libwinmedia.dart';

import '../../../firebase_options.dart';
import '../../../locator.dart';
import '../home_view.dart';
import 'splash_page.dart';

class FutureBuilderForSplash extends StatelessWidget {
  const FutureBuilderForSplash({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Init.instance.initialize(context),
      builder: (context, AsyncSnapshot snapshot) {
        // Show splash screen while waiting for app resources to load:
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const MaterialApp(home: Splash());
        } else {
          // Loading is done, return the app:
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            theme: context.watch<ThemeProvider>().theme,
            title: 'Material App',
            onGenerateRoute: RouteGenerator.routeGenerator,
            home: TrialSomething(), //BUNU NİYE YAZMAMIZ LAZIM ONU ANLAMADIM
          );
        }
      },
    );
  }
}

class Init {
  static Init? _instace;
  static bool isFirst = true;
  static Init get instance {
    _instace ??= Init._init();
    return _instace!;
  }

  Init._init();

  Future initialize(BuildContext context) async {
    if (!isFirst) {
      return;
    }
    isFirst = false;

    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    FirebaseAuth auth = FirebaseAuth.instance;

    auth.authStateChanges().listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
      }
    });

    await Hive.initFlutter();
    setupLocator();

    CoinCacheManager _cacheManager = locator<CoinCacheManager>();
    AppCacheManager _appCacheManager = locator<AppCacheManager>();

    await _cacheManager.init();
    await _appCacheManager.init();

    await dotenv.load(fileName: ".env");
    if (Platform.isWindows) {
      LWM.initialize();
    }

    GechoServiceController.instance.fetchGechoAllCoinListEveryTwoSecond();
    BitexenServiceController.instance.fetchBitexenCoinListEveryTwoSecond();
    TruncgilServiceController.instance.fetchTruncgilListEveryTwoSecond();
    //HurriyetServiceController.instance.fetchHurriyetStocksEveryTwoSecond();
    GenelParaServiceController.instance.fetchGenelParaStocksEveryTwoSecond();

    context.read<CoinCubit>().startCompare();
    context.read<CoinListCubit>().fetchAllCoins();
    context.read<BitexenCubit>().fetchAllCoins();
    context.read<TruncgilCubit>().fetchAllCoins();
    context.read<HurriyetCubit>().fetchAllCoins();
    await _appCacheManager.init();

    await Future.delayed(const Duration(seconds: 3));
  }
}

class TrialSomething extends StatelessWidget {
  TrialSomething({Key? key}) : super(key: key);
  AppCacheManager _cacheManager = locator<AppCacheManager>();

  open() {
    _cacheManager.putBoolItem(PreferencesKeys.IS_FIRST_APP.name, true);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _cacheManager
          .init(), // SOMETİMES BOX RETURN NULL L USED AWAİT BUT NOTHİNG CHANGED SO NOW L AM USİNG FUTURE BUİLDER FOR THİS İT'S WORKİNG.
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Splash(); // BU BÖYLE OLMAZ DÜZELT BUNU 2 FUTURE BUİLDER SAÇMALIK DÜZELT
        } else {
          if (_cacheManager.getBoolValue(PreferencesKeys.IS_FIRST_APP.name) ==
              "false") {
            open();
            return const OnboardPage();
          } else {
            //return LoginPageTwo();
            return const HomeView();
          }
        }
      },
    );
  }
}
