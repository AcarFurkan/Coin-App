import 'dart:async';

import '../../core/constant/app/app_constant.dart';
import '../../core/extension/string_extension.dart';
import '../coin/search_coin_page/view/search_page.dart';
import '../settings/view/settings_page.dart';
import '../../product/connectivity_manager/connectivity_notifer.dart';
import '../../product/language/locale_keys.g.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';

import '../../core/extension/context_extension.dart';
import '../../product/untility/basic_alert_dialog.dart';
import '../coin/bitexen/view/bitexen_page.dart';
import '../coin/bitexen/viewmodel/page_viewmodel/cubit/bitexen_page_general_cubit.dart';
import '../coin/hurriyet/viewmodel/page_viewmodel/cubit/hurriyet_page_general_state_dart_cubit.dart';
import '../coin/list_all_coin_page/view/coin_list_page.dart';
import '../coin/list_all_coin_page/viewmodel/page_viewmodel/cubit/list_page_general_cubit.dart';
import '../coin/selected_coin/view/selected_coin_page.dart';
import '../coin/selected_coin/viewmodel/general/cubit/selected_page_general_cubit.dart';
import '../coin/truncgil/viewmodel/page_viewmodel.dart/cubit/truncgil_page_general_cubit.dart';
import 'viewmodel/home_viewmodel.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final GlobalKey curvedKey = GlobalKey();
  final PageStorageKey pageStorageKey =
      const PageStorageKey<String>("pageview");

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance?.addPostFrameCallback((_) {
      //context.read<HomeViewModel>().animateToPage =
      //    context.read<HomeViewModel>().selectedIndex;
      context.read<ConnectivityNotifier>().setContext(context);
      context.read<ConnectivityNotifier>().init();
    });
    //if(){}
  }

  @override
  void dispose() {
    try {
      //TODO: L DİDNT SOLVE THAT PROBLEM I TRIED IT IN CONNECTİVİTY NOTIFER BUT L COUDNT L CATCH  IT.
      context.read<ConnectivityNotifier>().dispose();
    } catch (e) {
      print(e);
    }
    super.dispose();
  }

  List<Widget> listPage = [
    SelectedCoinPage(),
    CoinListPage(),
    BitexenPage(),
    //TruncgilPage(),
    SearchPage(),
    SettingsPage(),
    //HurriyetPage(),
  ];
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        extendBody: true,
        body: buildScaffoldBody(context),
        bottomNavigationBar: buildCurvedNavigationBar(context),
      ),
    );
  }
  /**
   * (
      key: PageStorageKey<String>("pageview"),
      controller: context.read<HomeViewModel>().pageController,
      onPageChanged: (index) =>
          context.read<HomeViewModel>().selectedIndex = index,
      children: listPage,
    );
   */

  PageView buildScaffoldBody(BuildContext context) {
    return PageView.builder(
        physics: const BouncingScrollPhysics(),
        key: pageStorageKey,
        itemCount: listPage.length,
        restorationId: "pageview",
        onPageChanged: (index) =>
            context.read<HomeViewModel>().selectedIndex = index,
        controller: context.read<HomeViewModel>().pageController,
        itemBuilder: (context, index) {
          return listPage[index];
        });
  }

  CurvedNavigationBar buildCurvedNavigationBar(BuildContext context) {
    return CurvedNavigationBar(
        key: curvedKey,
        color: context.theme.bottomNavigationBarTheme.backgroundColor ??
            context.theme.colorScheme.onError,
        buttonBackgroundColor:
            context.theme.bottomNavigationBarTheme.backgroundColor ??
                context.theme.colorScheme
                    .onError, //darktheme icon bg beyaz icon black
        backgroundColor: Colors.transparent,
        animationDuration: context.lowDuration,
        onTap: _onItemTapped,
        index: context.watch<HomeViewModel>().selectedIndex,
        items: buildCurvedBarItems);
  }

  Future<bool> _onWillPop() async {
    return (await showBasicAlertDialog(context,
            title: LocaleKeys.exitAlertDiolog_title.locale,
            content: LocaleKeys.exitAlertDiolog_content.locale)) ??
        false;
  }

  List<Widget> get buildCurvedBarItems => [
        Icon(
          Icons.home,
          color: tabbarLabelColorGenerator(0),
        ),
        SizedBox(
          height: context.height * .045,
          child: Image.asset(
            AppConstant.instance.BTC_ICON,
            color: tabbarLabelColorGenerator(1),
          ),
        ),
        Center(
          child: Icon(
            Icons.sports_football,
            color: tabbarLabelColorGenerator(2),
          ),
        ),
        Icon(
          // Icons.attach_money,
          Icons.add,
          color: tabbarLabelColorGenerator(3),
        ),
        Icon(
          //Icons.money,
          Icons.settings,

          color: tabbarLabelColorGenerator(4),
        ),
      ];

  Color tabbarLabelColorGenerator(int index) {
    if (context.read<HomeViewModel>().selectedIndex == index) {
      return context.theme.bottomNavigationBarTheme.selectedItemColor ??
          context.theme.colorScheme.primary;
    } else {
      return context.theme.bottomNavigationBarTheme.unselectedItemColor ??
          context.theme.colorScheme.primary;
    }
  }

  void _onItemTapped(int index) {
    context.read<HomeViewModel>().selectedIndex = index;
    context.read<HomeViewModel>().animateToPage = index;
    closeKeyBoardsAndUnFocus();
  }

  void closeKeyBoardsAndUnFocus() {
    if (context.read<ListPageGeneralCubit>().textEditingController != null) {
      context.read<ListPageGeneralCubit>().closeKeyBoardAndUnFocus();
    }
    if (context.read<SelectedPageGeneralCubit>().textEditingController !=
        null) {
      context.read<SelectedPageGeneralCubit>().closeKeyBoardAndUnFocus();
    }
    if (context.read<BitexenPageGeneralCubit>().searchTextEditingController !=
        null) {
      context.read<BitexenPageGeneralCubit>().closeKeyBoardAndUnFocus();
    }
    if (context
            .read<HurriyetPageGeneralStateDartCubit>()
            .searchTextEditingController !=
        null) {
      context
          .read<HurriyetPageGeneralStateDartCubit>()
          .closeKeyBoardAndUnFocus();
    }
    if (context.read<TruncgilPageGeneralCubit>().searchTextEditingController !=
        null) {
      context.read<TruncgilPageGeneralCubit>().closeKeyBoardAndUnFocus();
    }
  }
}
