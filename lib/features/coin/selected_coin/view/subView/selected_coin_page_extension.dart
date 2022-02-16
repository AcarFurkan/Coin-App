part of '../selected_coin_page.dart';

extension SelectedCoinBlocConsumerView on SelectedCoinPage {
  BlocConsumer _blocConsumer() {
    return BlocConsumer<CoinCubit, CoinState>(
      listener: (context, state) {
        if (state is CoinError) {
          if (context.read<ConnectivityNotifier>().connectionStatus ==
              ConnectivityResult.none) {
            context.read<ConnectivityNotifier>().showConnectionErrorSnackBar();
          } else {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.message)));
          }
        } else if (state is CoinAlarm) {
          showAlertDialog(state.itemFromDataBase, state.message, context);
        }
      },
      builder: (context, state) {
        if (state is CoinInitial) {
          context.read<CoinCubit>().startCompare();
          return const Center(
            child: CupertinoActivityIndicator(),
          );
        } else if (state is CoinLoading) {
          return const Center(child: CupertinoActivityIndicator());
        } else if (state is CoinCompleted) {
          return _buildCoinCompletedStateView(context, state);
        } else if (state is UpdateSelectedCoinPage) {
          return _updateCoinSelectedPageExtensionStateView(context, state);
        } else {
          return Center(child: Image.asset(AppConstant.instance.IMAGE_404));
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

  showAlertDialog(
      MainCurrencyModel coin, String message, BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text(message),
            actions: [
              CupertinoDialogAction(
                child: const Text("Stop"),
                onPressed: () async {
                  context.read<CoinCubit>().stopAudio();
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }
}
