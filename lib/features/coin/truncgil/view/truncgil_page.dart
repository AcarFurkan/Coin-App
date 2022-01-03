import '../../../../core/widget/text/locale_text.dart';
import '../../coin_detail_page/view/coin_detail_page.dart';
import '../viewmodel/cubit/truncgil_cubit.dart';
import '../viewmodel/page_viewmodel.dart/cubit/truncgil_page_general_cubit.dart';
import '../../../settings/view/settings_page.dart';
import '../../../../product/language/locale_keys.g.dart';
import '../../../../product/model/my_coin_model.dart';
import '../../../../product/widget/component/coin_current_info_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TruncgilPage extends StatelessWidget {
  TruncgilPage({Key? key}) : super(key: key);
  TextEditingController _searchTextEditingController = TextEditingController();
  GlobalKey<FormState> _searchFormKey = GlobalKey<FormState>();
  List<MainCurrencyModel> searchresult = [];

  @override
  Widget build(BuildContext context) {
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
          context.read<TruncgilPageGeneralCubit>().changeIsSearch();

          if (context.read<TruncgilPageGeneralCubit>().isSearhOpen == false) {
            _searchTextEditingController.clear();
          }
        },
        icon: const Icon(Icons.search));
  }

  BlocConsumer<TruncgilCubit, TruncgilState> _blocConsumer() {
    return BlocConsumer<TruncgilCubit, TruncgilState>(
      builder: (context, state) {
        if (state is TruncgilInitial) {
          context.read<TruncgilCubit>().fetchAllCoins();
          return _initialStateBody();
        } else if (state is TruncgilLoading) {
          return _loadingStateBody();
        } else if (state is TruncgilCompleted) {
          return completedStateBody(state, context);
        } else {
          return Text("Coin");
        }
      },
      listener: (context, state) {
        if (state is TruncgilError) {
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
  Widget completedStateBody(TruncgilCompleted state, BuildContext context) {
    List<MainCurrencyModel> coinListToShow = state.truncgilCoinsList;

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
        height: context.watch<TruncgilPageGeneralCubit>().isSearhOpen ? 50 : 0,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: AnimatedOpacity(
            curve: Curves.easeIn,
            duration: const Duration(milliseconds: 500),
            opacity:
                context.watch<TruncgilPageGeneralCubit>().isSearhOpen ? 1 : 0,
            child: TextFormField(
              cursorHeight:
                  context.watch<TruncgilPageGeneralCubit>().isSearhOpen
                      ? 18
                      : 0,
              controller: _searchTextEditingController,
              onChanged: (a) {
                context.read<TruncgilPageGeneralCubit>().textFormFieldChanged();
              },
              focusNode: context.watch<TruncgilPageGeneralCubit>().myFocusNode,
              autofocus: context.watch<TruncgilPageGeneralCubit>().isSearhOpen
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
                  context.read<TruncgilCubit>().updateFromFavorites(result);
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
      TruncgilCompleted state,
      BuildContext context) {
    coinListToShow = state.truncgilCoinsList;
    coinListToShow = searchTransaction(context, coinListToShow);
    return coinListToShow;
  }

  List<MainCurrencyModel> searchTransaction(
      BuildContext context, List<MainCurrencyModel> coinListToShow) {
    if (context.read<TruncgilPageGeneralCubit>().isSearhOpen &&
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
