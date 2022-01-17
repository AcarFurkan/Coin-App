import '../../../../core/extension/context_extension.dart';
import '../../../../product/untility/text_form_field_with_animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widget/text/locale_text.dart';
import '../../../../product/language/locale_keys.g.dart';
import '../../../../product/model/my_coin_model.dart';
import '../../../../product/widget/component/coin_current_info_card.dart';
import '../viewmodel/cubit/bitexen_cubit.dart';
import '../viewmodel/page_viewmodel/cubit/bitexen_page_general_cubit.dart';

class BitexenPage extends StatelessWidget {
  BitexenPage({Key? key}) : super(key: key);

  final List<MainCurrencyModel> searchresult = [];

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
            Navigator.pushNamed(context, "/settingsGeneral");
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
            context
                .read<BitexenPageGeneralCubit>()
                .searchTextEditingController
                ?.clear();
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
          return Text("404");
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
        buildTextFormFieldWithAnimation(
          context,
          controller: context
              .read<BitexenPageGeneralCubit>()
              .searchTextEditingController!,
          focusNode: context.watch<BitexenPageGeneralCubit>().myFocusNode,
          isSearchOpen: context.watch<BitexenPageGeneralCubit>().isSearhOpen,
          onChanged:
              context.read<BitexenPageGeneralCubit>().textFormFieldChanged(),
        ),
        Expanded(
          flex: (context.height * .02).toInt(),
          child: buildListViewBuilder(coinListToShow),
        ),
      ],
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
        context
                .read<BitexenPageGeneralCubit>()
                .searchTextEditingController
                ?.text !=
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
          .read<BitexenPageGeneralCubit>()
          .searchTextEditingController!
          .text
          .toLowerCase())) {
        searchresult.add(coinList[i]);
      }
    }
    return searchresult;
  }
}
