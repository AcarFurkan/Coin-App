import 'package:auto_size_text/auto_size_text.dart';
import '../../../../core/extension/context_extension.dart';
import '../../../../product/untility/text_form_field_with_animation.dart';
import '../../../authentication/viewmodel/cubit/user_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/enums/currency_enum.dart';
import '../../../../core/widget/text/locale_text.dart';
import '../../../../product/language/locale_keys.g.dart';
import '../../../../product/model/my_coin_model.dart';
import '../../../../product/widget/component/coin_current_info_card.dart';
import '../viewmodel/cubit/coin_list_cubit.dart';
import '../viewmodel/page_viewmodel/cubit/list_page_general_cubit.dart';

class CoinListPage extends StatelessWidget {
  CoinListPage({Key? key}) : super(key: key);

  final List<MainCurrencyModel> searchresult = [];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: context.read<UserCubit>().user?.level == 2
          ? CoinCurrencyLevel2
              .values.length /* 
          TODO: LEVEL TWO OLAYINI DÜŞÜN */
          : CoinCurrency.values.length,
      child: Scaffold(
        //extendBody: true,
        appBar: _appBar(context),
        body: TabBarView(children: tabBarViewGenerator(context)),
      ),
    );
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
          onPressed: () {
            Navigator.pushNamed(context, "/settingsGeneral");
          },
          icon: const Icon(Icons.settings)),
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
            context.read<ListPageGeneralCubit>().textEditingController?.clear();
          }
        },
        icon: const Icon(Icons.search));
  }

  TabBar buildTabBar(BuildContext context) {
    return TabBar(
        indicatorWeight: 0,
        unselectedLabelStyle: context.textTheme.bodyText2,
        indicator: BoxDecoration(
            border: Border(
                bottom: BorderSide(
                    color: context.colors.onBackground,
                    width: context.width * .008))),
        tabs: _tabGenerator(context));
  }

  List<Widget> tabBarViewGenerator(BuildContext context) {
    if (context.read<UserCubit>().user?.level == 2) {
      return CoinCurrencyLevel2.values
          .map(
            (e) => Center(child: _blocConsumer(e.name)),
          )
          .toList();
    } else {
      return CoinCurrency.values
          .map(
            (e) => Center(child: _blocConsumer(e.name)),
          )
          .toList();
    }
  }

  List<Tab> _tabGenerator(BuildContext context) {
    if (context.read<UserCubit>().user?.level == 2) {
      return CoinCurrencyLevel2.values
          .map((e) => Tab(
                child: AutoSizeText(
                  e.name,
                  maxLines: 1,
                ),
              ))
          .toList();
    } else {
      return CoinCurrency.values
          .map((e) => Tab(
                child: AutoSizeText(
                  e.name,
                  maxLines: 1,
                ),
              ))
          .toList();
    }
  }

  BlocConsumer<CoinListCubit, CoinListState> _blocConsumer(
      String currencyName) {
    return BlocConsumer<CoinListCubit, CoinListState>(
      builder: (context, state) {
        if (state is CoinListInitial) {
          context.read<CoinListCubit>().fetchAllCoins();
          return _initialStateBody;
        } else if (state is CoinListLoading) {
          return _loadingStateBody;
        } else if (state is CoinListCompleted) {
          return completedStateBody(state, currencyName, context);
        } else {
          return const Text("404"); /*
          TODO: BAŞKA BİR ŞEKİL DÜŞÜN */
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

  Center get _initialStateBody =>
      const Center(child: CupertinoActivityIndicator());
  Center get _loadingStateBody =>
      const Center(child: CupertinoActivityIndicator());
  Widget completedStateBody(
      CoinListCompleted state, String currencyName, BuildContext context) {
    List<MainCurrencyModel> coinListToShow = state.usdtCoinsList;

    coinListToShow = coinListToShowTransactions(
        currencyName, coinListToShow, state, context);

    return Column(
      children: [
        buildTextFormFieldWithAnimation(
          context,
          controller:
              context.read<ListPageGeneralCubit>().textEditingController!,
          focusNode: context.watch<ListPageGeneralCubit>().myFocusNode,
          isSearchOpen: context.watch<ListPageGeneralCubit>().isSearhOpen,
          onChanged:
              context.read<ListPageGeneralCubit>().textFormFieldChanged(),
        ),
        Expanded(
          flex: (context.height * .02).toInt(),
          child: buildListViewBuilder(coinListToShow, currencyName),
        ),
      ],
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
            onTap: () =>
                Navigator.pushNamed(context, "/detailPage", arguments: result),
            child: Hero(
              tag: result.id,
              child: ListCardItem(
                coin: result,
                index: index,
                voidCallback: () =>
                    context.read<CoinListCubit>().updateFromFavorites(result),
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
        context.read<ListPageGeneralCubit>().textEditingController?.text !=
            "") {
      coinListToShow = searchResult(coinListToShow, context);
    }
    return coinListToShow;
  }

  List<MainCurrencyModel> searchResult(
      List<MainCurrencyModel> coinList, BuildContext context) {
    searchresult.clear();

    for (int i = 0; i < coinList.length; i++) {
      String data = coinList[i].name;
      if (data.toLowerCase().contains(context
          .read<ListPageGeneralCubit>()
          .textEditingController!
          .text
          .toLowerCase())) {
        searchresult.add(coinList[i]);
      }
    }
    return searchresult;
  }
}
