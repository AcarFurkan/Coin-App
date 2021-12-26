part of '../selected_coin_page.dart';

extension SelectedCoinBlocConsumerView on SelectedCoinPage {
  BlocConsumer _blocConsumer() {
    return BlocConsumer<CoinCubit, CoinState>(
      listener: (context, state) {
        if (state is CoinError) {
          Scaffold.of(context)
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
          List<MyCoin> coinListToShow = (state.myCoinList ?? []);
          if (coinListToShow.isEmpty) {
            return Center(
              child: Text("OMG YOU DONT HAVE ANY FAVORITE COIN"),
            );
          }
          if (context.read<SelectedPageGeneralCubit>().isSearhOpen &&
              _searchTextEditingController.text != "") {
            coinListToShow = searchResult(coinListToShow);
          }
          return Column(
            children: [
              buildTextFormFieldWithAnimation(context),
              Expanded(
                child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: coinListToShow.length,
                    itemBuilder: (context, index) {
                      MyCoin result = coinListToShow[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (builder) =>
                                      CoinDetailPage(coin: result)));
                        },
                        onLongPress: () {
                          context
                              .read<CoinCubit>()
                              .updatePage(isSelected: false);
                        },
                        child: Hero(
                          tag: result.id,
                          child: ListCardItem(
                            coin: result,
                            voidCallback: () {
                              context
                                  .read<CoinCubit>()
                                  .saveDeleteFromFavorites(result);
                            },
                            index: index,
                          ),
                        ),
                      );
                    }),
              ),
            ],
          );
        } else if (state is UpdateSelectedCoinPage) {
          List<MyCoin> coinListToShow = state.myCoinList ?? [];
          if (context.read<SelectedPageGeneralCubit>().isSearhOpen &&
              _searchTextEditingController.text != "") {
            coinListToShow = searchResult(coinListToShow);
          }
          return Column(
            children: [
              Container(
                decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: const BorderRadius.vertical(
                      bottom: Radius.circular(15),
                    )
                    //  border: Border.all(color: Colors.black),
                    ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    OutlinedButton(
                      onPressed: () {
                        context.read<SelectedPageGeneralCubit>().changeValue();
                        if (context
                                .read<SelectedPageGeneralCubit>()
                                .isSelectedAll ==
                            true) {
                          context
                              .read<CoinCubit>()
                              .updatePage(isSelected: true);
                        } else {
                          context
                              .read<CoinCubit>()
                              .updatePage(isSelected: false);
                        }
                      },
                      child: context
                                  .watch<SelectedPageGeneralCubit>()
                                  .isSelectedAll ==
                              false
                          ? Text("Tümünü seç")
                          : Text("Tümünü Bırak"),
                    ),
                    OutlinedButton(
                        ///////// BUNU DA SEÇİLEN İTEM LİST BOŞSSA AKTİF ETME
                        onPressed: () {
                          context.read<CoinCubit>().deleteItemsFromDb();

                          context
                              .read<SelectedPageGeneralCubit>()
                              .isSelectedAll = false;

                          context.read<CoinCubit>().startAgain();
                          context.read<SelectedPageGeneralCubit>().isSearhOpen =
                              false;
                          _searchTextEditingController.clear();
                        },
                        child: Text("Seçilenleri sil")),
                    InkWell(
                      onTap: () {
                        context
                            .read<CoinCubit>()
                            .clearAllItemsFromToDeletedList();
                        context.read<SelectedPageGeneralCubit>().isSelectedAll =
                            false;
                        context.read<CoinCubit>().startAgain();
                        context.read<SelectedPageGeneralCubit>().isSearhOpen =
                            false;
                        _searchTextEditingController.clear();
                      },
                      child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.black),
                          ),
                          child: Icon(
                            Icons.close_sharp,
                            color: Colors.grey[700],
                          )),
                    )
                  ],
                ),
              ),
              context.watch<SelectedPageGeneralCubit>().isSearhOpen == true
                  ? SizedBox(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          onChanged: (a) {
                            context
                                .read<SelectedPageGeneralCubit>()
                                .textFormFieldChanged();
                          },
                          controller: _searchTextEditingController,
                          autofocus: true,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder()),
                        ),
                      ),
                    )
                  : const Text(
                      "",
                      style: TextStyle(fontSize: 0),
                    ),
              ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: coinListToShow.length,
                  itemBuilder: (context, index) {
                    MyCoin result = coinListToShow[index];
                    return RemovableCardItem(
                      result: result,
                      context: context,
                      isSelectedAll: state.isSelectedAll,
                    );
                  }),
            ],
          );
        } else {
          return const Text("Coin");
        }
      },
    );
  }

  Widget buildTextFormFieldWithAnimation(BuildContext context) {
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
              onChanged: (a) {
                context.read<SelectedPageGeneralCubit>().textFormFieldChanged();
              },
              focusNode: context.watch<SelectedPageGeneralCubit>().myFocusNode,
              autofocus: context.watch<SelectedPageGeneralCubit>().isSearhOpen
                  ? true
                  : false,
              decoration: const InputDecoration(border: OutlineInputBorder()),
            ),
          ),
        ),
      ),
    );
  }

  List<MyCoin> searchResult(List<MyCoin> coinList) {
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

class RemovableCardItem extends StatefulWidget {
  RemovableCardItem(
      {Key? key,
      required this.result,
      required this.context,
      required this.isSelectedAll})
      : super(key: key);
  final MyCoin result;
  final BuildContext context;
  bool isSelectedAll;

  @override
  State<RemovableCardItem> createState() => _RemovableCardItemState();
}

class _RemovableCardItemState extends State<RemovableCardItem> {
  getColorForPrice() {
    if (widget.result.priceControl == "INCREASING") {
      return Colors.green;
    } else if (widget.result.priceControl == "DESCREASING") {
      return Colors.red;
    } else {
      return Colors.black;
    }
  }

  getColorForPercentage() {
    if (widget.result.percentageControl == "INCREASING") {
      return Colors.green;
    } else if (widget.result.percentageControl == "DESCREASING") {
      return Colors.red;
    } else {
      return Colors.black;
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTapAction();
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.result.name,
                style: Theme.of(context).textTheme.headline6,
              ),
              Spacer(),
              Text(
                (widget.result.changeOf24H ?? "0") + " %",
                style: TextStyle(color: getColorForPercentage()),
              ),
              Spacer(),
              Text(
                "${widget.result.lastPrice} ${widget.result.counterCurrencyCode == "USDT" ? "\$" : widget.result.counterCurrencyCode == "TRY" ? "₺" : "₿"}  ",
                style: TextStyle(color: getColorForPrice()),
                //style: Theme.of(context).textTheme.headline6,
              ),

              Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.all(Radius.circular(15))),
                child: Opacity(opacity: rr(), child: Icon(Icons.close)),
              ),

              // Icon
            ],
          ),
        ),
      ),
    );
  }

  double rr() {
    if (widget.isSelectedAll == true) {
      context.read<CoinCubit>().addItemToBeDeletedList(widget.result.id);
      return 1;
    } else {
      context.read<CoinCubit>().removeItemFromBeDeletedList(widget.result.id);
      return 0;
    }
  }

  void onTapAction() {
    setState(() {
      widget.isSelectedAll = !widget.isSelectedAll;
    });
  }
}
