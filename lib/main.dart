import 'dart:io';

import 'core/enums/locale_keys_enum.dart';
import 'features/authentication/onboard/view/onboard_page.dart';
import 'features/coin/bitexen/viewmodel/cubit/bitexen_cubit.dart';
import 'features/coin/bitexen/viewmodel/page_viewmodel/cubit/bitexen_page_general_cubit.dart';
import 'features/coin/hurriyet/viewmodel/cubit/hurriyet_cubit.dart';
import 'features/coin/hurriyet/viewmodel/page_viewmodel/cubit/hurriyet_page_general_state_dart_cubit.dart';
import 'features/coin/truncgil/viewmodel/cubit/truncgil_cubit.dart';
import 'features/coin/truncgil/viewmodel/page_viewmodel.dart/cubit/truncgil_page_general_cubit.dart';
import 'product/repository/cache/app_cache_manager.dart';
import 'product/repository/service/bitexen/bitexen_service_controller.dart';
import 'product/repository/service/genelpara/genepara_service_controller.dart';
import 'product/repository/service/truncgil/truncgil_service_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'features/coin/selected_coin/viewmodel/general/cubit/selected_page_general_cubit.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'features/settings/subpage/audio_settings/viewmodel/cubit/audio_cubit.dart';
import 'firebase_options.dart';
import 'product/repository/service/gecho/gecho_service_controller.dart';

import 'features/coin/coin_detail_page/viewmodel/cubit/cubit/coin_detail_cubit.dart';

import 'features/coin/list_all_coin_page/viewmodel/page_viewmodel/cubit/list_page_general_cubit.dart';
import 'product/theme/theme_provider.dart';
import 'package:provider/provider.dart';

import 'core/constant/app/app_constant.dart';
import 'product/language/language_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'features/coin/list_all_coin_page/viewmodel/cubit/coin_list_cubit.dart';
import 'features/coin/selected_coin/viewmodel/cubit/coin_cubit.dart';
import 'locator.dart';
import 'product/repository/cache/coin_cache_manager.dart';
import 'package:libwinmedia/libwinmedia.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  runApp(ChangeNotifierProvider(
    create: (context) => ThemeProvider(),
    child: EasyLocalization(
        child: const MyApp(),
        supportedLocales: LanguageManager.instance.supportedLocales,
        fallbackLocale: const Locale('en', 'US'),
        path: AppConstant.LANG_ASSET_PATH),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<CoinListCubit>(
          create: (BuildContext context) => CoinListCubit(),
        ),
        BlocProvider<CoinDetailCubit>(
          create: (BuildContext context) => CoinDetailCubit(),
        ),
        BlocProvider<ListPageGeneralCubit>(
          create: (BuildContext context) =>
              ListPageGeneralCubit(context: context),
        ),
        BlocProvider<SelectedPageGeneralCubit>(
          create: (BuildContext context) =>
              SelectedPageGeneralCubit(context: context),
        ),
        BlocProvider<AudioCubit>(
          create: (BuildContext context) => AudioCubit(),
        ),
        BlocProvider<BitexenCubit>(
          create: (BuildContext context) => BitexenCubit(),
        ),
        BlocProvider<BitexenPageGeneralCubit>(
          create: (BuildContext context) =>
              BitexenPageGeneralCubit(context: context),
        ),
        BlocProvider<TruncgilCubit>(
          create: (BuildContext context) => TruncgilCubit(),
        ),
        BlocProvider<TruncgilPageGeneralCubit>(
          create: (BuildContext context) =>
              TruncgilPageGeneralCubit(context: context),
        ),
        BlocProvider<HurriyetCubit>(
          create: (BuildContext context) => HurriyetCubit(),
        ),
        BlocProvider<HurriyetPageGeneralStateDartCubit>(
          create: (BuildContext context) =>
              HurriyetPageGeneralStateDartCubit(context: context),
        ),
        BlocProvider<CoinCubit>(
          create: (BuildContext context) => CoinCubit(context: context),
        )
      ],
      child: const FutureBuilderForSplash(),
    );
  }
}

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
            home: TrialSomething(),
          );
        }
      },
    );
  }
}

class Splash extends StatelessWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool lightMode =
        MediaQuery.of(context).platformBrightness == Brightness.light;
    return Scaffold(
      backgroundColor:
          lightMode ? const Color(0xff1D1D1D) : const Color(0xff1D1D1D),
      body: Center(
          child: lightMode
              ? Image.asset('assets/gif/splash35.gif')
              : Image.asset('assets/gif/splash35.gif')),
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
    print("1111111111111111111111111111111111111");
    if (!isFirst) {
      print("333333333333333333333");

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
    print("2222222222222222222222222222");

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
          return const OnboardPage();
        } else {
          print(_cacheManager.getBoolValue(PreferencesKeys.IS_FIRST_APP.name));
          print(1);
          print("object");
          if (_cacheManager.getBoolValue(PreferencesKeys.IS_FIRST_APP.name) ==
              "false") {
            print(1);
            open();

            return const OnboardPage();
          } else {
            print(
                _cacheManager.getBoolValue(PreferencesKeys.IS_FIRST_APP.name));
            print(4);
            return const OnboardPage();

            //return const HomeView();
          }
        }
      },
    );
  }
}
