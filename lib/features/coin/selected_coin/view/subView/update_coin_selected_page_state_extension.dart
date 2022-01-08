part of '../selected_coin_page.dart';

extension UpdateCoinSelectedPageExtension on SelectedCoinPage {
  Widget _updateCoinSelectedPageExtensionStateView(
      BuildContext context, UpdateSelectedCoinPage state) {
    List<MainCurrencyModel> coinListToShow = state.myCoinList ?? [];
    if (context.read<SelectedPageGeneralCubit>().isSearhOpen &&
        _searchTextEditingController.text != "") {
      coinListToShow = searchResult(coinListToShow);
    }
    return Column(
      children: [
        Expanded(flex: 1, child: buildSelectedAndDeleteContainer(context)),
        Expanded(
            flex: context.watch<SelectedPageGeneralCubit>().isSearhOpen == true
                ? 1
                : 0,
            child: buildSearchBox(context)),
        Expanded(
          flex: 13,
          child: _buildListVieBuilder(coinListToShow, state),
        ),
      ],
    );
  }

  Container buildSelectedAndDeleteContainer(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 10, bottom: 5),
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.vertical(
        bottom: Radius.circular(15),
      )),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildSelectAndDropButton(context),
          _buildDeleteButton(context),
          InkWell(
            onTap: () {
              closeIconTransactions(context);
            },
            child: buildCloseIcon(),
          )
        ],
      ),
    );
  }

  Widget buildSearchBox(BuildContext context) {
    return context.watch<SelectedPageGeneralCubit>().isSearhOpen == true
        ? SizedBox(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: _buildSearchBoxTextFormField(context),
            ),
          )
        : Container();
  }

  TextFormField _buildSearchBoxTextFormField(BuildContext context) {
    return TextFormField(
      onChanged: (a) =>
          context.read<SelectedPageGeneralCubit>().textFormFieldChanged(),
      controller: _searchTextEditingController,
      autofocus: true,
      decoration: const InputDecoration(border: OutlineInputBorder()),
    );
  }

  ListView _buildListVieBuilder(
      List<MainCurrencyModel> coinListToShow, UpdateSelectedCoinPage state) {
    return ListView.builder(
        physics: const BouncingScrollPhysics(),
        shrinkWrap: true,
        itemCount: coinListToShow.length,
        itemBuilder: (context, index) {
          MainCurrencyModel result = coinListToShow[index];
          return RemovableCardItem(
            currency: result,
            context: context,
            isSelectedAll: state.isSelectedAll,
          );
        });
  }

  OutlinedButton _buildDeleteButton(BuildContext context) {
    return OutlinedButton(
        ///////// BUNU DA SEÇİLEN İTEM LİST BOŞSSA AKTİF ETME
        onPressed: () => deleteButtonTransactions(context),
        child: Text("Seçilenleri sil"));
  }

  OutlinedButton _buildSelectAndDropButton(BuildContext context) {
    return OutlinedButton(
      onPressed: () => buildSelectedAndDropButtonActions(context),
      child: context.watch<SelectedPageGeneralCubit>().isSelectedAll == false
          ? Text("Tümünü seç")
          : Text("Tümünü Bırak"),
    );
  }

  void closeIconTransactions(BuildContext context) {
    context.read<CoinCubit>().clearAllItemsFromToDeletedList();
    context.read<SelectedPageGeneralCubit>().isSelectedAll = false;
    context.read<CoinCubit>().startAgain();
    context.read<SelectedPageGeneralCubit>().isSearhOpen = false;
    _searchTextEditingController.clear();
  }

  Container buildCloseIcon() {
    return Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.black),
        ),
        child: Icon(
          Icons.close_sharp,
          color: Colors.grey[700],
        ));
  }

  void deleteButtonTransactions(BuildContext context) {
    context.read<CoinCubit>().deleteItemsFromDb();

    context.read<SelectedPageGeneralCubit>().isSelectedAll = false;

    context.read<CoinCubit>().startAgain();
    context.read<SelectedPageGeneralCubit>().isSearhOpen = false;
    _searchTextEditingController.clear();
  }

  void buildSelectedAndDropButtonActions(BuildContext context) {
    context.read<SelectedPageGeneralCubit>().changeValue();
    if (context.read<SelectedPageGeneralCubit>().isSelectedAll == true) {
      context.read<CoinCubit>().updatePage(isSelected: true);
    } else {
      context.read<CoinCubit>().updatePage(isSelected: false);
    }
  }
}
