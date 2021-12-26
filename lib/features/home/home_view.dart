import 'package:coin_with_architecture/features/coin/list_all_coin_page/viewmodel/page_viewmodel/cubit/list_page_general_cubit.dart';
import 'package:coin_with_architecture/features/coin/selected_coin/viewmodel/general/cubit/selected_page_general_cubit.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/src/provider.dart';

import '../coin/list_all_coin_page/view/coin_list_page.dart';
import '../coin/selected_coin/view/selected_coin_page.dart';
import '../settings/view/settings_page.dart';
import "dart:math" show pi;

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  List listPage = [
    SelectedCoinPage(),
    CoinListPage(),
    SettingsPage(),
  ];
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: listPage.length, vsync: this);
    print("initState");
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      print("WidgetsBinding");
    });
    SchedulerBinding.instance!.addPostFrameCallback((_) {
      print("SchedulerBinding");
    });
    //idgetsBinding.instance!.addPostFrameCallback((_) {
    // labelColor = Theme.of(context).tabBarTheme.labelColor ??
    //     Theme.of(context).colorScheme.primary;
    // unselectedLabelColor =
    //     Theme.of(context).tabBarTheme.unselectedLabelColor ??
    //         Theme.of(context).colorScheme.primary;
    // });
  }

  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    if (context.read<ListPageGeneralCubit>().textEditingController != null) {
      context.read<ListPageGeneralCubit>().closeKeyBoardAndUnFocus();
    }
    if (context.read<SelectedPageGeneralCubit>().textEditingController !=
        null) {
      context.read<SelectedPageGeneralCubit>().closeKeyBoardAndUnFocus();
    }
    setState(() {
      print("aaaaaaaaaa");
      _selectedIndex = index;
    });
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => CupertinoAlertDialog(
            title: const Text('Are you sure?'),
            content: const Text('Do you want to exit an App'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;
  }

  _tabBarView() {
    return AnimatedBuilder(
      animation: (_tabController.animation as Animation<double>),
      builder: (BuildContext context, snapshot) {
        return Transform.rotate(
          angle: _tabController.animation!.value * pi,
          child: [
            Container(
              color: Colors.blue,
            ),
            Container(
              color: Colors.orange,
            ),
            Container(
              color: Colors.lightGreen,
            ),
            Container(
              color: Colors.red,
            ),
          ][_tabController.animation!.value.round()],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        extendBody: true,
        body: listPage[_selectedIndex],
        bottomNavigationBar: CurvedNavigationBar(
            key: _bottomNavigationKey,
            color: Theme.of(context).colorScheme.onPrimary,
            buttonBackgroundColor: Theme.of(context).colorScheme.onPrimary,
            backgroundColor: Colors.transparent,
            animationDuration: Duration(milliseconds: 450),
            //color: Theme.of(context).colorScheme.secondaryVariant,
            onTap: _onItemTapped,
            items: [
              Icon(
                Icons.home,
                color: tabbarLabelColorGenerator(0),
              ),
              Icon(
                Icons.search,
                color: tabbarLabelColorGenerator(1),
              ),
              Icon(
                Icons.settings,
                color: tabbarLabelColorGenerator(2),
              ),
            ]),
      ),
    );
  }

  Color tabbarLabelColorGenerator(int index) {
    if (_selectedIndex == index) {
      return Theme.of(context).colorScheme.background;
    } else {
      return Theme.of(context).tabBarTheme.unselectedLabelColor ??
          Theme.of(context).colorScheme.primary;
    }
  }
}

/**
 * 
 *  BottomNavigationBarItem(
                icon: Icon(Icons.home), label: LocaleKeys.home_tab1.locale),
            BottomNavigationBarItem(
                icon: Icon(Icons.home), label: LocaleKeys.home_tab2.locale),
            BottomNavigationBarItem(
                icon: Icon(Icons.home), label: LocaleKeys.home_tab3.locale),
            BottomNavigationBarItem(
                icon: Icon(Icons.home), label: LocaleKeys.home_tab4.locale)
 */

/**

DotNavigationBar(
          backgroundColor: Colors.grey[100],
          currentIndex: _selectedIndex,
          unselectedItemColor: Colors.grey[500],
          selectedItemColor: Colors.amber[800],
          onTap: _onItemTapped,
          items: [
            DotNavigationBarItem(
              icon: Icon(Icons.home),
            ),
            DotNavigationBarItem(
              icon: Icon(Icons.search),
            ),
            DotNavigationBarItem(
              icon: Icon(Icons.details),
            ),
            DotNavigationBarItem(
              icon: Icon(Icons.settings),
            )
          ])

 */