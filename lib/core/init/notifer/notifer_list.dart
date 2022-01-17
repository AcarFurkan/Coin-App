import '../../../features/coin/bitexen/viewmodel/cubit/bitexen_cubit.dart';
import '../../../features/coin/bitexen/viewmodel/page_viewmodel/cubit/bitexen_page_general_cubit.dart';
import '../../../features/coin/coin_detail_page/viewmodel/cubit/cubit/coin_detail_cubit.dart';
import '../../../features/coin/hurriyet/viewmodel/cubit/hurriyet_cubit.dart';
import '../../../features/coin/hurriyet/viewmodel/page_viewmodel/cubit/hurriyet_page_general_state_dart_cubit.dart';
import '../../../features/coin/list_all_coin_page/viewmodel/cubit/coin_list_cubit.dart';
import '../../../features/coin/list_all_coin_page/viewmodel/page_viewmodel/cubit/list_page_general_cubit.dart';
import '../../../features/coin/selected_coin/viewmodel/cubit/coin_cubit.dart';
import '../../../features/coin/selected_coin/viewmodel/general/cubit/selected_page_general_cubit.dart';
import '../../../features/coin/truncgil/viewmodel/cubit/truncgil_cubit.dart';
import '../../../features/coin/truncgil/viewmodel/page_viewmodel.dart/cubit/truncgil_page_general_cubit.dart';
import '../../../features/settings/subpage/audio_settings/viewmodel/cubit/audio_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../../../features/authentication/viewmodel/cubit/user_cubit.dart';
import '../../../features/home/viewmodel/home_viewmodel.dart';
import '../../../main.dart';
import '../../../product/theme/theme_provider.dart';

class ApplicationProvider {
  static ApplicationProvider? _instance;
  static ApplicationProvider get instance {
    _instance ??= ApplicationProvider._init();
    return _instance!;
  }

  ApplicationProvider._init();

  List<SingleChildWidget> providers = [
    ChangeNotifierProvider(create: (context) => ThemeProvider()),
    ChangeNotifierProvider(create: (context) => HomeViewModel()),
    BlocProvider<UserCubit>(
        create: (BuildContext context) => UserCubit(),
        child: const FutureBuilderForSplash()),
    BlocProvider<CoinListCubit>(
      create: (BuildContext context) => CoinListCubit(),
    ),
    BlocProvider<CoinDetailCubit>(
      create: (BuildContext context) => CoinDetailCubit(),
    ),
    BlocProvider<ListPageGeneralCubit>(
      create: (BuildContext context) => ListPageGeneralCubit(context: context),
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
  ];
}
