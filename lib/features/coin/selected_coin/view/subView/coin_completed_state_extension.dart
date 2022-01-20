part of '../selected_coin_page.dart';

extension CoinCompletedStateExtension on SelectedCoinPage {
  Widget _buildCoinCompletedStateView(
      BuildContext context, CoinCompleted state) {
    List<MainCurrencyModel> coinListToShow = (state.myCoinList ?? []);
    if (coinListToShow.isEmpty) return _buildDontHaveCoin(context);

    if (context.read<SelectedPageGeneralCubit>().isSearhOpen &&
        _searchTextEditingController.text != "") {
      coinListToShow = searchResult(coinListToShow);
    }
    return Column(
      children: [
        buildTextFormFieldWithAnimation(context,
            onChanged:
                context.read<SelectedPageGeneralCubit>().textFormFieldChanged(),
            controller: _searchTextEditingController,
            focusNode: context.watch<SelectedPageGeneralCubit>().myFocusNode,
            isSearchOpen:
                context.watch<SelectedPageGeneralCubit>().isSearhOpen),
        Expanded(
          child: _buildListViewBuilder(coinListToShow),
        ),
      ],
    );
  }

  ListView _buildListViewBuilder(List<MainCurrencyModel> coinListToShow) {
    return ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: coinListToShow.length,
        itemBuilder: (context, index) {
          MainCurrencyModel result = coinListToShow[index];
          return GestureDetector(
            onTap: () =>
                Navigator.pushNamed(context, "/detailPage", arguments: result),
            onLongPress: () =>
                context.read<CoinCubit>().updatePage(isSelected: false),
            child: _buildListCardItem(result, context, index),
          );
        });
  }

  Hero _buildListCardItem(
      MainCurrencyModel result, BuildContext context, int index) {
    return Hero(
      tag: result.id,
      child: ListCardItem(
        coin: result,
        voidCallback: () =>
            context.read<CoinCubit>().saveDeleteFromFavorites(result),
        index: index,
      ),
    );
  }

  ListView _buildDontHaveCoin(BuildContext context) {
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: context.width * .05),
      children: [
        SizedBox(
          height: context.height * 0.12,
        ),
        SizedBox(
            height: context.height * 0.5,
            child: InkWell(
                onTap: () {
                  context.read<HomeViewModel>().selectedIndex =
                      context.read<HomeViewModel>().selectedIndex + 1;
                  context.read<HomeViewModel>().animateToPage =
                      context.read<HomeViewModel>().selectedIndex;
                },
                child: SvgPicture.asset("assets/svg/add.svg"))),
      ],
    );
  }
}
