import 'dart:io';

import 'package:coin_with_architecture/features/coin/bitexen/viewmodel/cubit/bitexen_cubit.dart';
import 'package:coin_with_architecture/features/coin/bitexen/viewmodel/page_viewmodel/cubit/bitexen_page_general_cubit.dart';
import 'package:coin_with_architecture/features/coin/hurriyet/viewmodel/cubit/hurriyet_cubit.dart';
import 'package:coin_with_architecture/features/coin/hurriyet/viewmodel/page_viewmodel/cubit/hurriyet_page_general_state_dart_cubit.dart';
import 'package:coin_with_architecture/features/coin/truncgil/viewmodel/cubit/truncgil_cubit.dart';
import 'package:coin_with_architecture/features/coin/truncgil/viewmodel/page_viewmodel.dart/cubit/truncgil_page_general_cubit.dart';
import 'package:coin_with_architecture/product/repository/service/bitexen/bitexen_service_controller.dart';
import 'package:coin_with_architecture/product/repository/service/genelpara/genelpara_service.dart';
import 'package:coin_with_architecture/product/repository/service/genelpara/genepara_service_controller.dart';
import 'package:coin_with_architecture/product/repository/service/truncgil/truncgil_service.dart';
import 'package:coin_with_architecture/product/repository/service/truncgil/truncgil_service_controller.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';

import 'features/coin/selected_coin/viewmodel/general/cubit/selected_page_general_cubit.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'features/settings/audio_settings/viewmodel/cubit/audio_cubit.dart';
import 'product/repository/service/gecho/gecho_service_controller.dart';

import 'features/coin/coin_detail_page/viewmodel/cubit/cubit/coin_detail_cubit.dart';

import 'features/coin/list_all_coin_page/viewmodel/page_viewmodel/cubit/list_page_general_cubit.dart';
import 'product/repository/service/hurriyet/hurriyet_service_controller.dart';
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
  await dotenv.load(fileName: ".env");
  await EasyLocalization.ensureInitialized();
  await Hive.initFlutter();
  setupLocator();
  if (Platform.isWindows) {
    LWM.initialize();
  }

  GechoServiceController.instance.fetchGechoAllCoinListEveryTwoSecond();
  BitexenServiceController.instance.fetchBitexenCoinListEveryTwoSecond();
  TruncgilServiceController.instance.fetchTruncgilListEveryTwoSecond();
  HurriyetServiceController.instance.fetchHurriyetStocksEveryTwoSecond();
  GenelParaServiceController.instance.fetchGenelParaStocksEveryTwoSecond();

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

class MyApp2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Material App Bar'),
        ),
        body: Center(
          child: ListView(
            children: [
              Icon(TablerIcons.coin),
              Icon(TablerIcons.currency_bahraini),
              Icon(TablerIcons.currency_bath),
              Icon(TablerIcons.currency_bitcoin),
              Icon(TablerIcons.currency_cent),
              Icon(TablerIcons.currency_dinar),
              Icon(TablerIcons.currency_dirham),
              Icon(TablerIcons.currency_dollar_australian),
              Icon(TablerIcons.currency_dollar_canadian),
              Icon(TablerIcons.currency_dollar_singapore),
              Icon(TablerIcons.currency_dollar),
              Icon(TablerIcons.currency_ethereum),
              Icon(TablerIcons.currency_euro),
              Icon(TablerIcons.currency_forint),
              Icon(TablerIcons.currency_frank),
              Icon(TablerIcons.currency_krone_czech),
              Icon(TablerIcons.currency_krone_danish),
              Icon(TablerIcons.currency_krone_swedish),
              Icon(TablerIcons.currency_leu),
              Icon(TablerIcons.currency_lira),
              Icon(TablerIcons.currency_litecoin),
              Icon(TablerIcons.currency_naira),
              Icon(TablerIcons.currency_pound),
              Icon(TablerIcons.currency_real),
              Icon(TablerIcons.currency_renminbi),
              Icon(TablerIcons.currency_ripple),
              Icon(TablerIcons.currency_riyal),
              Icon(TablerIcons.currency_rubel),
              Icon(TablerIcons.currency_rupee),
              Icon(TablerIcons.currency_shekel),
              Icon(TablerIcons.currency_taka),
              Icon(TablerIcons.currency_tugrik),
              Icon(TablerIcons.currency_won),
              Icon(TablerIcons.currency_yen),
              Icon(TablerIcons.currency_zloty),
              Icon(TablerIcons.current_location),
            ],
          ),
        ),
      ),
    );
  }
}
