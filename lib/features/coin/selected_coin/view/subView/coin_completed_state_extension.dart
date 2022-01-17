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
        _buildTextFormFieldWithAnimation(context),
        Expanded(
          child: _buildListViewBuilder(coinListToShow),
        ),
      ],
    );
  }

  Widget _buildTextFormFieldWithAnimation(BuildContext context) {
    return AnimatedSize(
      curve: Curves.decelerate,
      duration: const Duration(milliseconds: 1000),
      child: SizedBox(
        height: context.watch<SelectedPageGeneralCubit>().isSearhOpen ? 50 : 0,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 500),
            opacity:
                context.watch<SelectedPageGeneralCubit>().isSearhOpen ? 1 : 0,
            child: TextFormField(
              cursorHeight:
                  context.watch<SelectedPageGeneralCubit>().isSearhOpen
                      ? 18
                      : 0,
              controller: _searchTextEditingController,
              cursorColor: Theme.of(context).colorScheme.onBackground,
              onChanged: (a) {
                context.read<SelectedPageGeneralCubit>().textFormFieldChanged();
              },
              focusNode: context.watch<SelectedPageGeneralCubit>().myFocusNode,
              autofocus: context.watch<SelectedPageGeneralCubit>().isSearhOpen
                  ? true
                  : false,
              //  decoration: const InputDecoration(border: OutlineInputBorder()),
            ),
          ),
        ),
      ),
    );
  }
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
    padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * .05),
    children: [
      SizedBox(
        height: MediaQuery.of(context).size.height * 0.04,
      ),
      SizedBox(
          height: MediaQuery.of(context).size.height * 0.5,
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
