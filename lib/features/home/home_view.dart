import "dart:math" show pi;

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/src/provider.dart';

import '../coin/bitexen/view/bitexen_page.dart';
import '../coin/bitexen/viewmodel/page_viewmodel/cubit/bitexen_page_general_cubit.dart';
import '../coin/hurriyet/view/hurriyet_page.dart';
import '../coin/hurriyet/viewmodel/page_viewmodel/cubit/hurriyet_page_general_state_dart_cubit.dart';
import '../coin/list_all_coin_page/view/coin_list_page.dart';
import '../coin/list_all_coin_page/viewmodel/page_viewmodel/cubit/list_page_general_cubit.dart';
import '../coin/selected_coin/view/selected_coin_page.dart';
import '../coin/selected_coin/viewmodel/general/cubit/selected_page_general_cubit.dart';
import '../coin/truncgil/view/truncgil_page.dart';
import '../coin/truncgil/viewmodel/page_viewmodel.dart/cubit/truncgil_page_general_cubit.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView>
    with SingleTickerProviderStateMixin {
  GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  static final PageController _pageController = PageController(
    initialPage: _selectedIndex,
    keepPage: true,
  );
  List<Widget> listPage = [
    SelectedCoinPage(),
    CoinListPage(),
    BitexenPage(),
    TruncgilPage(),
    // aa(),
    HurriyetPage(),
  ];

  @override
  void initState() {
    super.initState();
  }

  static int _selectedIndex = 0;
  void _onItemTapped(int index) {
    if (context.read<ListPageGeneralCubit>().textEditingController != null) {
      context.read<ListPageGeneralCubit>().closeKeyBoardAndUnFocus();
    }
    if (context.read<SelectedPageGeneralCubit>().textEditingController !=
        null) {
      context.read<SelectedPageGeneralCubit>().closeKeyBoardAndUnFocus();
    }
    if (context.read<BitexenPageGeneralCubit>().textEditingController != null) {
      context.read<BitexenPageGeneralCubit>().closeKeyBoardAndUnFocus();
    }
    if (context
            .read<HurriyetPageGeneralStateDartCubit>()
            .textEditingController !=
        null) {
      context
          .read<HurriyetPageGeneralStateDartCubit>()
          .closeKeyBoardAndUnFocus();
    }
    if (context.read<TruncgilPageGeneralCubit>().textEditingController !=
        null) {
      context.read<TruncgilPageGeneralCubit>().closeKeyBoardAndUnFocus();
    }
    setState(() {
      // _pageController.jumpToPage(index);
      _pageController.animateToPage(index,
          duration: const Duration(milliseconds: 700), curve: Curves.ease);
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

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        extendBody: true,
        body: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          children: listPage,
        ),
        bottomNavigationBar: CurvedNavigationBar(
            key: _bottomNavigationKey,
            color: Theme.of(context).colorScheme.onPrimary,
            buttonBackgroundColor: Theme.of(context).colorScheme.onPrimary,
            backgroundColor: Colors.transparent,
            animationDuration: Duration(milliseconds: 450),
            //color: Theme.of(context).colorScheme.secondaryVariant,
            onTap: _onItemTapped,
            index: _selectedIndex,
            items: [
              Icon(
                Icons.home,
                color: tabbarLabelColorGenerator(0),
              ),
              SizedBox(
                height: 35,
                child: Image.asset(
                  "assets/icon/btcIcon.png",
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
                Icons.attach_money,
                color: tabbarLabelColorGenerator(3),
              ),
              //Icon(
              //  Icons.search,
              //  color: tabbarLabelColorGenerator(3),
              //),

              Icon(
                Icons.money,
                color: tabbarLabelColorGenerator(4),
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