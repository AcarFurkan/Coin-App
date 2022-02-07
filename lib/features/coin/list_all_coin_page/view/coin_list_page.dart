import 'package:auto_size_text/auto_size_text.dart';
import '../../../../core/constant/app/app_constant.dart';
import '../../selected_coin/viewmodel/cubit/coin_cubit.dart';
import '../../selected_coin/viewmodel/general/cubit/selected_page_general_cubit.dart';
import '../../../../product/connectivity_manager/connectivity_notifer.dart';
import '../../../../product/model/coin/my_coin_model.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../../../../core/extension/context_extension.dart';
import '../../../../product/widget/component/text_form_field_with_animation.dart';
import '../../../authentication/viewmodel/cubit/user_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/enums/currency_enum.dart';
import '../../../../core/widget/text/locale_text.dart';
import '../../../../product/language/locale_keys.g.dart';
import '../../../../product/widget/component/coin_current_info_card.dart';
import '../viewmodel/cubit/coin_list_cubit.dart';
import '../viewmodel/page_viewmodel/cubit/list_page_general_cubit.dart';
part 'subview/sort_popup_extension.dart';

class CoinListPage extends StatelessWidget {
  CoinListPage({Key? key}) : super(key: key);
//  final GlobalKey _menuKey = GlobalKey();

  final List<MainCurrencyModel> searchresult = [];

  @override
  Widget build(BuildContext context) {
    print("111111111111111111");
    return DefaultTabController(
      length: CoinCurrency.values.length,
      child: Scaffold(
        //extendBody: true,
        appBar: _appBar(context),
        body: TabBarView(children: tabBarViewGenerator(context)),
      ),
    );
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      //  leading: IconButton(
      //      onPressed: () => Navigator.pushNamed(context, "/settingsGeneral"),
      //      icon: const Icon(Icons.settings)),
      titleSpacing: 0,
      actions: buildAppBarActions(context),
      bottom: buildTabBar(context),
      title: const LocaleText(text: LocaleKeys.coinListPage_appBarTitle),
    );
  }

  List<Widget> buildAppBarActions(BuildContext context) {
    return [
      //IconButton(
      //    onPressed: () => Navigator.pushNamed(context, "/searchPage"),
      //    icon: const Icon(Icons.add)),
      IconButton(
          onPressed: () {
            context.read<ListPageGeneralCubit>().changeIsSearch();

            if (context.read<ListPageGeneralCubit>().isSearhOpen == false) {
              context
                  .read<ListPageGeneralCubit>()
                  .textEditingController
                  ?.clear();
            }
          },
          icon: const Icon(Icons.search))
    ];
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
    return CoinCurrency.values
        .map(
          (e) => Center(child: _blocBuilder(e.name)),
        )
        .toList();
  }

  List<Tab> _tabGenerator(BuildContext context) {
    return CoinCurrency.values
        .map((e) => Tab(
              child: AutoSizeText(
                e.name,
                maxLines: 1,
              ),
            ))
        .toList();
  }

  //_trial(String currencyName, BuildContext context) {
  //  List<MainCurrencyModel> list = context.watch<CoinListCubit>().tryCoins;
  //  return BlocBuilder<CoinListCubit, CoinListState>(
  //    buildWhen: (previous, current) => previous != current,
  //    builder: (context, state) {
  //      if (state is CoinListInitial) {
  //        context.read<CoinListCubit>().fetchAllCoins();
  //        return _initialStateBody;
  //      } else if (state is CoinListLoading) {
  //        return _loadingStateBody;
  //      } else if (state is CoinListCompleted) {
  //        print("5555555555555555");

  //        return completedStateBody(state, currencyName, context);
  //      } else {
  //        return Center(child: Image.asset(AppConstant.instance.IMAGE_404));
  //      }
  //    },
  //  );
  //}

  BlocBuilder<CoinListCubit, CoinListState> _blocBuilder(String currencyName) {
    return BlocBuilder<CoinListCubit, CoinListState>(
      buildWhen: (previous, current) => previous != current,
      builder: (context, state) {
        if (state is CoinListInitial) {
          context.read<CoinListCubit>().fetchAllCoins();
          return _initialStateBody;
        } else if (state is CoinListLoading) {
          return _loadingStateBody;
        } else if (state is CoinListCompleted) {
          print("5555555555555555");

          return completedStateBody(state, currencyName, context);
        } else {
          return Center(child: Image.asset(AppConstant.instance.IMAGE_404));
        }
      },
    );
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
          return Center(child: Image.asset(AppConstant.instance.IMAGE_404));
        }
      },
      listener: (context, state) {
        if (state is CoinListError) {
          if (context.read<ConnectivityNotifier>().connectionStatus ==
              ConnectivityResult.none) {
            context.read<ConnectivityNotifier>().showConnectionErrorSnackBar();
          } else {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.message)));
          }
        }
      },
    );
  }

  GlobalKey menuKeyTransactions(String currency, BuildContext context) {
    if (currency == CoinCurrency.USD.name) {
      return context.read<ListPageGeneralCubit>().menuKeyUSD;
    } else if (currency == CoinCurrency.ETH.name) {
      return context.read<ListPageGeneralCubit>().menuKeyETH;
    } else if (currency == CoinCurrency.TRY.name) {
      return context.read<ListPageGeneralCubit>().menuKeyTRY;
    } else if (currency == CoinCurrency.BTC.name) {
      return context.read<ListPageGeneralCubit>().menuKeyBTC;
    } else if (currency == CoinCurrency.NEW.name) {
      return context.read<ListPageGeneralCubit>().menuKeyNEW;
    } else {
      return context.read<ListPageGeneralCubit>().menuKeyUSD;
    }
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
        Padding(
          padding: context.paddingLowHorizontal,
          child: SizedBox(
            height: context.lowValue * 4,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Expanded(flex: 5, child: Text("  Sembol")),
                const Spacer(flex: 2),
                const Expanded(flex: 5, child: Text(" LastPrice")),
                Expanded(
                    flex: 6,
                    child: buildOrderByPopupMenu(
                        context, menuKeyTransactions(currencyName, context))),
              ],
            ),
          ),
        ),
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
    print(currencyName);
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

    coinListToShow = context.read<CoinListCubit>().orderList(
        context.read<ListPageGeneralCubit>().getorderByDropDownValue,
        coinListToShow);
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
