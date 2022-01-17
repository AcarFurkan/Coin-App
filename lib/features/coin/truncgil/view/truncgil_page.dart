import '../../../../core/extension/context_extension.dart';
import '../../../../product/untility/text_form_field_with_animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widget/text/locale_text.dart';
import '../../../../product/language/locale_keys.g.dart';
import '../../../../product/model/my_coin_model.dart';
import '../../../../product/widget/component/coin_current_info_card.dart';
import '../viewmodel/cubit/truncgil_cubit.dart';
import '../viewmodel/page_viewmodel.dart/cubit/truncgil_page_general_cubit.dart';

class TruncgilPage extends StatelessWidget {
  TruncgilPage({Key? key}) : super(key: key);
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
          context.read<TruncgilPageGeneralCubit>().changeIsSearch();

          if (context.read<TruncgilPageGeneralCubit>().isSearhOpen == false) {
            context
                .read<TruncgilPageGeneralCubit>()
                .searchTextEditingController
                ?.clear();
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
        buildTextFormFieldWithAnimation(
          context,
          controller: context
              .read<TruncgilPageGeneralCubit>()
              .searchTextEditingController!,
          focusNode: context.watch<TruncgilPageGeneralCubit>().myFocusNode,
          isSearchOpen: context.watch<TruncgilPageGeneralCubit>().isSearhOpen,
          onChanged:
              context.read<TruncgilPageGeneralCubit>().textFormFieldChanged(),
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
            onTap: () =>
                Navigator.pushNamed(context, "/detailPage", arguments: result),
            child: Hero(
              tag: result.id,
              child: ListCardItem(
                coin: result,
                index: index,
                voidCallback: () =>
                    context.read<TruncgilCubit>().updateFromFavorites(result),
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
        context
                .read<TruncgilPageGeneralCubit>()
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
          .read<TruncgilPageGeneralCubit>()
          .searchTextEditingController!
          .text
          .toLowerCase())) {
        searchresult.add(coinList[i]);
      }
    }
    return searchresult;
  }
}
