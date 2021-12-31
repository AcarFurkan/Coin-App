import 'package:coin_with_architecture/core/widget/text/locale_text.dart';
import 'package:coin_with_architecture/features/coin/bitexen/viewmodel/cubit/bitexen_cubit.dart';
import 'package:coin_with_architecture/features/coin/bitexen/viewmodel/page_viewmodel/cubit/bitexen_page_general_cubit.dart';
import 'package:coin_with_architecture/features/coin/coin_detail_page/view/coin_detail_page.dart';
import 'package:coin_with_architecture/features/settings/view/settings_page.dart';
import 'package:coin_with_architecture/product/language/locale_keys.g.dart';
import 'package:coin_with_architecture/product/model/my_coin_model.dart';
import 'package:coin_with_architecture/product/widget/component/coin_current_info_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BitexenPage extends StatelessWidget {
  BitexenPage({Key? key}) : super(key: key);

  TextEditingController _searchTextEditingController = TextEditingController();
  GlobalKey<FormState> _searchFormKey = GlobalKey<FormState>();
  List<MainCurrencyModel> searchresult = [];

  @override
  Widget build(BuildContext context) {
    context.read<BitexenPageGeneralCubit>().textEditingController =
        _searchTextEditingController;
    return Scaffold(
      //extendBody: true,
      appBar: _appBar(context),
      body: _blocConsumer(),
    );
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => SettingsPage()));
          },
          icon: const Icon(Icons.settings)),
      titleSpacing: 0,
      actions: [
        buildAppBarActions(context),
      ],
      title: const LocaleText(text: LocaleKeys.coinListPage_appBarTitle),
    );
  }

  IconButton buildAppBarActions(BuildContext context) {
    return IconButton(
        onPressed: () {
          context.read<BitexenPageGeneralCubit>().changeIsSearch();

          if (context.read<BitexenPageGeneralCubit>().isSearhOpen == false) {
            _searchTextEditingController.clear();
          }
        },
        icon: const Icon(Icons.search));
  }

  BlocConsumer<BitexenCubit, BitexenState> _blocConsumer() {
    return BlocConsumer<BitexenCubit, BitexenState>(
      builder: (context, state) {
        if (state is BitexenInitial) {
          context.read<BitexenCubit>().fetchAllCoins();
          return _initialStateBody();
        } else if (state is BitexenLoading) {
          return _loadingStateBody();
        } else if (state is BitexenCompleted) {
          return completedStateBody(state, context);
        } else {
          return Text("Coin");
        }
      },
      listener: (context, state) {
        if (state is BitexenError) {
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
  Widget completedStateBody(BitexenCompleted state, BuildContext context) {
    List<MainCurrencyModel> coinListToShow = state.bitexenCoinsList;

    coinListToShow = coinListToShowTransactions(coinListToShow, state, context);

    return Column(
      children: [
        buildTextFormFieldWithAnimation(context),
        Expanded(
          flex: 10,
          child: buildListViewBuilder(coinListToShow),
        ),
      ],
    );
  }

  Widget buildTextFormFieldWithAnimation(BuildContext context) {
    return AnimatedSize(
      curve: Curves.decelerate,
      duration: const Duration(milliseconds: 1000),
      child: SizedBox(
        height: context.watch<BitexenPageGeneralCubit>().isSearhOpen ? 50 : 0,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: AnimatedOpacity(
            curve: Curves.easeIn,
            duration: const Duration(milliseconds: 500),
            opacity:
                context.watch<BitexenPageGeneralCubit>().isSearhOpen ? 1 : 0,
            child: TextFormField(
              cursorHeight:
                  context.watch<BitexenPageGeneralCubit>().isSearhOpen ? 18 : 0,
              controller: _searchTextEditingController,
              onChanged: (a) {
                context.read<BitexenPageGeneralCubit>().textFormFieldChanged();
              },
              focusNode: context.watch<BitexenPageGeneralCubit>().myFocusNode,
              autofocus: context.watch<BitexenPageGeneralCubit>().isSearhOpen
                  ? true
                  : false,
              decoration: const InputDecoration(border: OutlineInputBorder()),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildListViewBuilder(List<MainCurrencyModel> coinListToShow) {
    return Scrollbar(
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: coinListToShow.length,
        itemBuilder: (context, index) {
          var result = coinListToShow[index];

          return GestureDetector(
            onTap: () {
              // convertCurrency(context, currencyName, coinListToShow, index);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CoinDetailPage(coin: result)));
            },
            child: Hero(
              tag: result.id,
              child: ListCardItem(
                coin: result,
                index: index,
                voidCallback: () {
                  context.read<BitexenCubit>().updateFromFavorites(result);
                },
              ),
            ),
          );
        },
      ),
    );
  }

  List<MainCurrencyModel> coinListToShowTransactions(
      List<MainCurrencyModel> coinListToShow,
      BitexenCompleted state,
      BuildContext context) {
    coinListToShow = state.bitexenCoinsList;
    coinListToShow = searchTransaction(context, coinListToShow);
    return coinListToShow;
  }

  List<MainCurrencyModel> searchTransaction(
      BuildContext context, List<MainCurrencyModel> coinListToShow) {
    if (context.read<BitexenPageGeneralCubit>().isSearhOpen &&
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
