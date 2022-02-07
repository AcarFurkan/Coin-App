import 'package:auto_size_text/auto_size_text.dart';
import '../../../../core/constant/app/app_constant.dart';
import '../../selected_coin/viewmodel/cubit/coin_cubit.dart';
import '../../../../product/model/coin/my_coin_model.dart';

import '../../../../core/extension/context_extension.dart';
import '../../../../product/widget/component/text_form_field_with_animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widget/text/locale_text.dart';
import '../../../../product/language/locale_keys.g.dart';
import '../../../../product/widget/component/coin_current_info_card.dart';
import '../viewmodel/cubit/truncgil_cubit.dart';
import '../viewmodel/page_viewmodel.dart/cubit/truncgil_page_general_cubit.dart';
part './subview/sort_popup_extension.dart';

class TruncgilPage extends StatelessWidget {
  TruncgilPage({Key? key}) : super(key: key);
  final List<MainCurrencyModel> searchresult = [];
  final GlobalKey _menuKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context),
      body: _blocConsumer(),
    );
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      leading: IconButton(
          onPressed: () {
            Navigator.pushNamed(context, "/settingsGeneral");
          },
          icon: const Icon(Icons.settings)),
      titleSpacing: 0,
      actions: [
        buildAppBarActions(context),
      ],
      title: const LocaleText(text: LocaleKeys.currencyPage_appBarTitle),
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
          return Center(child: Image.asset(AppConstant.instance.IMAGE_404));
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
        Padding(
          padding: context.paddingLowHorizontal,
          child: SizedBox(
            height: context.lowValue * 4,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(flex: 4, child: Text("  Sembol")),
                const Spacer(flex: 4),
                Expanded(flex: 5, child: Text(" LastPrice")),
                const Spacer(),
                Expanded(flex: 8, child: buildOrderByPopupMenu(context)),
              ],
            ),
          ),
        ),
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
    coinListToShow = context.read<TruncgilCubit>().orderList(
        context.read<TruncgilPageGeneralCubit>().getorderByDropDownValue,
        coinListToShow);
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
