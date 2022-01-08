part of '../selected_coin_page.dart';

extension SelectedCoinBlocConsumerView on SelectedCoinPage {
  BlocConsumer _blocConsumer() {
    return BlocConsumer<CoinCubit, CoinState>(
      listener: (context, state) {
        if (state is CoinError) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (context, state) {
        if (state is CoinInitial) {
          context.read<CoinCubit>().startCompare();
          return const Center(
            child: CupertinoActivityIndicator(),
          );
        } else if (state is CoinLoading) {
          return Center(child: CupertinoActivityIndicator());
        } else if (state is CoinCompleted) {
          return _buildCoinCompletedStateView(context, state);
        } else if (state is UpdateSelectedCoinPage) {
          return _updateCoinSelectedPageExtensionStateView(context, state);
        } else {
          return const Text("Coin");
        }
      },
    );
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
