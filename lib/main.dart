import 'package:easy_localization/easy_localization.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:provider/provider.dart';

import 'core/constant/app/app_constant.dart';
import 'features/authentication/viewmodel/cubit/user_cubit.dart';
import 'features/coin/bitexen/viewmodel/cubit/bitexen_cubit.dart';
import 'features/coin/bitexen/viewmodel/page_viewmodel/cubit/bitexen_page_general_cubit.dart';
import 'features/coin/coin_detail_page/viewmodel/cubit/cubit/coin_detail_cubit.dart';
import 'features/coin/hurriyet/viewmodel/cubit/hurriyet_cubit.dart';
import 'features/coin/hurriyet/viewmodel/page_viewmodel/cubit/hurriyet_page_general_state_dart_cubit.dart';
import 'features/coin/list_all_coin_page/viewmodel/cubit/coin_list_cubit.dart';
import 'features/coin/list_all_coin_page/viewmodel/page_viewmodel/cubit/list_page_general_cubit.dart';
import 'features/coin/selected_coin/viewmodel/cubit/coin_cubit.dart';
import 'features/coin/selected_coin/viewmodel/general/cubit/selected_page_general_cubit.dart';
import 'features/coin/truncgil/viewmodel/cubit/truncgil_cubit.dart';
import 'features/coin/truncgil/viewmodel/page_viewmodel.dart/cubit/truncgil_page_general_cubit.dart';
import 'features/home/landing_page.dart/landing_page.dart';
import 'features/home/landing_page.dart/splash_page.dart';
import 'features/settings/subpage/audio_settings/viewmodel/cubit/audio_cubit.dart';
import 'product/language/language_manager.dart';

import 'product/theme/theme_provider.dart';
import 'product/untility/navigation/route_generator.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  runApp(ChangeNotifierProvider(
    create: (context) => ThemeProvider(),
    child: EasyLocalization(
        child: BlocProvider<UserCubit>(
            create: (BuildContext context) => UserCubit(),
            child: const MyApp()),
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
            create: (BuildContext context) => CoinCubit(context: context)),
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
            onGenerateRoute: RouteGenerator.routeGenerator,
            home: TrialSomething(), //BUNU NİYE YAZMAMIZ LAZIM ONU ANLAMADIM
          );
        }
      },
    );
  }
}
