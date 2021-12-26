import 'dart:io';

import 'features/coin/selected_coin/viewmodel/general/cubit/selected_page_general_cubit.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'features/settings/audio_settings/viewmodel/cubit/audio_cubit.dart';
import 'product/viewmodel/service_viewmodel.dart';

import 'features/coin/coin_detail_page/viewmodel/cubit/cubit/coin_detail_cubit.dart';

import 'features/coin/list_all_coin_page/viewmodel/page_viewmodel/cubit/list_page_general_cubit.dart';
import 'product/theme/theme_provider.dart';
import 'package:provider/provider.dart';

import 'core/constant/app/app_constant.dart';
import 'features/home/home_view.dart';
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
  /* await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );*/
  await dotenv.load(fileName: ".env");
  await EasyLocalization.ensureInitialized();
  await Hive.initFlutter();
  setupLocator();
  if (Platform.isWindows) {
    LWM.initialize();
  }

  ServiceViewModel _serviceViewModel = locator<ServiceViewModel>();
  _serviceViewModel.fetchCoinListEveryTwoSecond();
  CoinCacheManager _cacheManager =
      locator<CoinCacheManager>(); //kapatmayı düşün

  _cacheManager.init();

  runApp(ChangeNotifierProvider(
    create: (context) => ThemeProvider(),
    child: EasyLocalization(
        child: MyApp(),
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
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          theme: context.watch<ThemeProvider>().theme,
          title: 'Material App',
          home: TrialSomething(),
        ));
  }
}

class TrialSomething extends StatelessWidget {
  const TrialSomething({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CoinCubit>(
      create: (BuildContext context) => CoinCubit(context: context),
      child: HomeView(),
    );
  }
}
