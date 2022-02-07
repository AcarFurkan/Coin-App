import 'dart:io';

import 'package:flutter/services.dart';

import '../onboard/view/onboard_page.dart';
import '../../../product/repository/cache/added_coin_list_externally_cache_manager.dart';
import '../../../product/repository/cache/coin_id_list_cache_manager.dart';
import '../../../product/theme/theme_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:provider/src/provider.dart';

import '../../../core/enums/locale_keys_enum.dart';
import '../../../core/extension/context_extension.dart';
import '../../../firebase_options.dart';
import '../../../locator.dart';
import '../../../product/repository/cache/app_cache_manager.dart';
import '../../../product/repository/cache/coin_cache_manager.dart';
import '../../../product/repository/service/market/bitexen/bitexen_service_controller.dart';
import '../../../product/repository/service/market/gecho/gecho_service_controller.dart';
import '../../../product/repository/service/market/genelpara/genepara_service_controller.dart';
import '../../../product/repository/service/market/truncgil/truncgil_service_controller.dart';
import '../../coin/bitexen/viewmodel/cubit/bitexen_cubit.dart';
import '../../coin/hurriyet/viewmodel/cubit/hurriyet_cubit.dart';
import '../../coin/list_all_coin_page/viewmodel/cubit/coin_list_cubit.dart';
import '../../coin/selected_coin/viewmodel/cubit/coin_cubit.dart';
import '../../coin/truncgil/viewmodel/cubit/truncgil_cubit.dart';
import '../home_view.dart';
import 'splash_page.dart';

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

    await JustAudioBackground.init(
      androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
      androidNotificationChannelName: 'Audio playback',
      androidNotificationOngoing: true,
    );
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    await Hive.initFlutter();
    setupLocator();

    CoinCacheManager _cacheManager = locator<CoinCacheManager>();
    AppCacheManager _appCacheManager = locator<AppCacheManager>();
    CoinIdListCacheManager _coinIdListCacheManager =
        locator<CoinIdListCacheManager>();
    AddedCoinListExternally _listCoinIdCacheManager =
        locator<AddedCoinListExternally>();

    await _cacheManager.init();
    await _appCacheManager.init();
    await _listCoinIdCacheManager.init();
    await _coinIdListCacheManager.init();

    await dotenv.load(fileName: ".env");
    // if (Platform.isWindows) {
    //   LWM.initialize();
    // }

    GechoServiceController.instance.fetchGechoAllCoinListEveryTwoSecond();
    BitexenServiceController.instance.fetchBitexenCoinListEveryTwoSecond();
    TruncgilServiceController.instance.fetchTruncgilListEveryTwoSecond();
    //HurriyetServiceController.instance.fetchHurriyetStocksEveryTwoSecond();
    GenelParaServiceController.instance.fetchGenelParaStocksEveryTwoSecond();
    await context.read<CoinCubit>().startCompare();
    await context.read<CoinListCubit>().fetchAllCoins();
    await context.read<BitexenCubit>().fetchAllCoins();
    await context.read<TruncgilCubit>().fetchAllCoins();
    await context.read<HurriyetCubit>().fetchAllCoins();

    context.read<ThemeProvider>().getThemeFromLocale();

    await Future.delayed(context.highDuration);
  }
}

class FutureBuilderForIsFirstOpen extends StatelessWidget {
  FutureBuilderForIsFirstOpen({Key? key}) : super(key: key);
  final AppCacheManager _cacheManager = locator<AppCacheManager>();

  Future<void> open() async {
    await _cacheManager.putBoolItem(PreferencesKeys.IS_FIRST_APP.name, true);
  }

  Future futureAction(BuildContext context) async {
    await _cacheManager.init();
    //  context.read<ThemeProvider>().getThemeFromLocale();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: futureAction(
          context), // SOMETİMES BOX RETURN NULL L USED AWAİT BUT NOTHİNG CHANGED SO NOW L AM USİNG FUTURE BUİLDER FOR THİS İT'S WORKİNG.
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Splash(); // BU BÖYLE OLMAZ DÜZELT BUNU 2 FUTURE BUİLDER SAÇMALIK DÜZELT
        } else {
          if (_cacheManager.getBoolValue(PreferencesKeys.IS_FIRST_APP.name) ==
              "false") {
            open();
            return const OnboardPage();
          } else {
            return const HomeView();
          }
        }
      },
    );
  }
}
