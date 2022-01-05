import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/enums/currency_enum.dart';
import '../../../../core/widget/text/locale_text.dart';
import '../../../../product/language/locale_keys.g.dart';
import '../../../../product/model/my_coin_model.dart';
import '../../../../product/widget/component/coin_current_info_card.dart';
import '../../../settings/view/settings_page.dart';
import '../../coin_detail_page/view/coin_detail_page.dart';
import '../viewmodel/cubit/coin_list_cubit.dart';
import '../viewmodel/page_viewmodel/cubit/list_page_general_cubit.dart';

class CoinListPage extends StatelessWidget {
  CoinListPage({Key? key}) : super(key: key);

  TextEditingController _searchTextEditingController = TextEditingController();
  GlobalKey<FormState> _searchFormKey = GlobalKey<FormState>();
  List<MainCurrencyModel> searchresult = [];

  @override
  Widget build(BuildContext context) {
    context.read<ListPageGeneralCubit>().textEditingController =
        _searchTextEditingController;
    return DefaultTabController(
      length: CoinCurrency.values.length,
      child: Scaffold(
        //extendBody: true,
        appBar: _appBar(context),
        body: TabBarView(children: tabBarViewGenerator(context)),
        drawer: Drawer(
          child: SettingsPage(),
        ),
      ),
    );
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      //leading: IconButton(
      //   onPressed: () {
      //   Navigator.pushNamed(context, "/settingsGeneral");
      //   },
      //   icon: const Icon(Icons.settings)),
      titleSpacing: 0,
      actions: [
        buildAppBarActions(context),
      ],
      //pinned: true,
      //floating: true,
      bottom: buildTabBar(context),
      title: const LocaleText(text: LocaleKeys.coinListPage_appBarTitle),
    );
  }

  IconButton buildAppBarActions(BuildContext context) {
    return IconButton(
        onPressed: () {
          context.read<ListPageGeneralCubit>().changeIsSearch();

          if (context.read<ListPageGeneralCubit>().isSearhOpen == false) {
            _searchTextEditingController.clear();
          }
        },
        icon: const Icon(Icons.search));
  }

  TabBar buildTabBar(BuildContext context) {
    return TabBar(
        indicatorColor: Theme.of(context).colorScheme.onPrimary,
        labelColor: Theme.of(context).colorScheme.onPrimary,
        indicatorWeight: 0,
        // labelStyle: Theme.of(context).textTheme.bodyText1,
        unselectedLabelStyle: Theme.of(context).textTheme.bodyText2,
        indicator: BoxDecoration(
            border: Border(
                bottom: BorderSide(
                    color: Theme.of(context).colorScheme.onPrimary, width: 3))),
        tabs: _tabGenerator());
  }

  List<Widget> tabBarViewGenerator(BuildContext context) {
    return CoinCurrency.values
        .map(
          (e) => Center(child: _blocConsumer(e.name)),
        )
        .toList();
  }

  List<Tab> _tabGenerator() {
    return CoinCurrency.values
        .map((e) => Tab(
              child: AutoSizeText(
                e.name,
                maxLines: 1,
              ),
            ))
        .toList();
  }

  BlocConsumer<CoinListCubit, CoinListState> _blocConsumer(
      String currencyName) {
    return BlocConsumer<CoinListCubit, CoinListState>(
      builder: (context, state) {
        if (state is CoinListInitial) {
          context.read<CoinListCubit>().fetchAllCoins();
          return _initialStateBody();
        } else if (state is CoinListLoading) {
          return _loadingStateBody();
        } else if (state is CoinListCompleted) {
          return completedStateBody(state, currencyName, context);
        } else {
          return Text("Coin");
        }
      },
      listener: (context, state) {
        if (state is CoinListError) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
    );
  }

  Center _initialStateBody() =>
      const Center(child: CupertinoActivityIndicator());
  Center _loadingStateBody() =>
      const Center(child: CupertinoActivityIndicator());
  Widget completedStateBody(
      CoinListCompleted state, String currencyName, BuildContext context) {
    List<MainCurrencyModel> coinListToShow = state.usdtCoinsList;

    coinListToShow = coinListToShowTransactions(
        currencyName, coinListToShow, state, context);

    return Column(
      children: [
        buildTextFormFieldWithAnimation(context),
        Expanded(
          flex: 10,
          child: buildListViewBuilder(coinListToShow, currencyName),
        ),
      ],
    );
  }

  Widget buildTextFormFieldWithAnimation(BuildContext context) {
    return AnimatedSize(
      curve: Curves.decelerate,
      duration: const Duration(milliseconds: 1000),
      child: SizedBox(
        height: context.watch<ListPageGeneralCubit>().isSearhOpen ? 50 : 0,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: AnimatedOpacity(
            curve: Curves.easeIn,
            duration: const Duration(milliseconds: 500),
            opacity: context.watch<ListPageGeneralCubit>().isSearhOpen ? 1 : 0,
            child: TextFormField(
              cursorHeight:
                  context.watch<ListPageGeneralCubit>().isSearhOpen ? 18 : 0,
              controller: _searchTextEditingController,
              onChanged: (a) {
                context.read<ListPageGeneralCubit>().textFormFieldChanged();
              },
              focusNode: context.watch<ListPageGeneralCubit>().myFocusNode,
              autofocus: context.watch<ListPageGeneralCubit>().isSearhOpen
                  ? true
                  : false,
              decoration: const InputDecoration(border: OutlineInputBorder()),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildListViewBuilder(
      List<MainCurrencyModel> coinListToShow, String currencyName) {
    return Scrollbar(
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: coinListToShow.length,
        itemBuilder: (context, index) {
          var result = coinListToShow[index];

          return GestureDetector(
            onTap: () {
              // convertCurrency(context, currencyName, coinListToShow, index);
              Navigator.pushNamed(context, "/detailPage", arguments: result);
            },
            child: Hero(
              tag: result.id,
              child: ListCardItem(
                coin: result,
                index: index,
                voidCallback: () {
                  context.read<CoinListCubit>().updateFromFavorites(result);
                },
              ),
            ),
          );
        },
      ),
    );
  }

  List<MainCurrencyModel> coinListToShowTransactions(
      String currencyName,
      List<MainCurrencyModel> coinListToShow,
      CoinListCompleted state,
      BuildContext context) {
    if (currencyName == CoinCurrency.TRY.name) {
      coinListToShow = state.tryCoinsList;
    } else if (currencyName == CoinCurrency.BTC.name) {
      coinListToShow = state.btcCoinsList;
    } else if (currencyName == CoinCurrency.ETH.name) {
      coinListToShow = state.ethCoinsList;
    } else if (currencyName == CoinCurrency.NEW.name) {
      coinListToShow = state.newUsdCoinsList;
    } else {
      coinListToShow = state.usdtCoinsList;
    }

    coinListToShow = searchTransaction(context, coinListToShow);
    return coinListToShow;
  }

  List<MainCurrencyModel> searchTransaction(
      BuildContext context, List<MainCurrencyModel> coinListToShow) {
    if (context.read<ListPageGeneralCubit>().isSearhOpen &&
        _searchTextEditingController.text != "") {
      coinListToShow = searchResult(coinListToShow);
    }
    return coinListToShow;
  }

  List<MainCurrencyModel> searchResult(List<MainCurrencyModel> coinList) {
    searchresult.clear();

    for (int i = 0; i < coinList.length; i++) {
      String data = coinList[i].name;
      if (data
          .toLowerCase()
          .contains(_searchTextEditingController.text.toLowerCase())) {
        searchresult.add(coinList[i]);
      }
    }
    return searchresult;
  }
}
