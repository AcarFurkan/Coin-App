import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/src/provider.dart';

import '../../../../core/widget/text/locale_text.dart';
import '../../../../product/language/locale_keys.g.dart';
import '../../../../product/model/my_coin_model.dart';
import '../../../../product/widget/component/coin_current_info_card.dart';
import '../../../settings/view/settings_page.dart';
import '../../coin_detail_page/view/coin_detail_page.dart';
import '../viewmodel/cubit/hurriyet_cubit.dart';
import '../viewmodel/page_viewmodel/cubit/hurriyet_page_general_state_dart_cubit.dart';

class HurriyetPage extends StatelessWidget {
  HurriyetPage({Key? key}) : super(key: key);

  TextEditingController _searchTextEditingController = TextEditingController();
  GlobalKey<FormState> _searchFormKey = GlobalKey<FormState>();
  List<MainCurrencyModel> searchresult = [];

  @override
  Widget build(BuildContext context) {
    context.read<HurriyetPageGeneralStateDartCubit>().textEditingController =
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
            Navigator.pushNamed(context, "settingsGeneral");
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
          context.read<HurriyetPageGeneralStateDartCubit>().changeIsSearch();

          if (context.read<HurriyetPageGeneralStateDartCubit>().isSearhOpen ==
              false) {
            _searchTextEditingController.clear();
          }
        },
        icon: const Icon(Icons.search));
  }

  BlocConsumer<HurriyetCubit, HurriyetState> _blocConsumer() {
    return BlocConsumer<HurriyetCubit, HurriyetState>(
      builder: (context, state) {
        if (state is HurriyetInitial) {
          context.read<HurriyetCubit>().fetchAllCoins();
          return _initialStateBody();
        } else if (state is HurriyetLoading) {
          return _loadingStateBody();
        } else if (state is HurriyetCompleted) {
          return completedStateBody(state, context);
        } else {
          return Text("Coin");
        }
      },
      listener: (context, state) {
        if (state is HurriyetError) {
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
  Widget completedStateBody(HurriyetCompleted state, BuildContext context) {
    List<MainCurrencyModel> coinListToShow = state.hurriyetCoinsList;

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
        height: context.watch<HurriyetPageGeneralStateDartCubit>().isSearhOpen
            ? 50
            : 0,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: AnimatedOpacity(
            curve: Curves.easeIn,
            duration: const Duration(milliseconds: 500),
            opacity:
                context.watch<HurriyetPageGeneralStateDartCubit>().isSearhOpen
                    ? 1
                    : 0,
            child: TextFormField(
              cursorHeight:
                  context.watch<HurriyetPageGeneralStateDartCubit>().isSearhOpen
                      ? 18
                      : 0,
              controller: _searchTextEditingController,
              onChanged: (a) {
                context
                    .read<HurriyetPageGeneralStateDartCubit>()
                    .textFormFieldChanged();
              },
              focusNode: context
                  .watch<HurriyetPageGeneralStateDartCubit>()
                  .myFocusNode,
              autofocus:
                  context.watch<HurriyetPageGeneralStateDartCubit>().isSearhOpen
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
              Navigator.pushNamed(context, "/detailPage", arguments: result);
            },
            child: Hero(
              tag: result.id,
              child: ListCardItem(
                coin: result,
                index: index,
                voidCallback: () {
                  context.read<HurriyetCubit>().updateFromFavorites(result);
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
      HurriyetCompleted state,
      BuildContext context) {
    coinListToShow = state.hurriyetCoinsList;
    coinListToShow = searchTransaction(context, coinListToShow);
    return coinListToShow;
  }

  List<MainCurrencyModel> searchTransaction(
      BuildContext context, List<MainCurrencyModel> coinListToShow) {
    if (context.read<HurriyetPageGeneralStateDartCubit>().isSearhOpen &&
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
