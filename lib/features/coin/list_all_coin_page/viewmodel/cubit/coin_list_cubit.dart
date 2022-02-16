import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:coin_with_architecture/product/repository/service/market/opensea/opensea_service_controller.dart';
import '../../../selected_coin/viewmodel/cubit/coin_cubit.dart';
import '../../../../../product/model/coin/my_coin_model.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import '../../../../../core/model/response_model/IResponse_model.dart';
import '../../../../../locator.dart';
import '../../../../../product/repository/cache/coin_cache_manager.dart';
import '../../../../../product/repository/service/market/gecho/gecho_service_controller.dart';

part 'coin_list_state.dart';

class CoinListCubit extends Cubit<CoinListState> {
  CoinListCubit() : super(CoinListInitial());
  final CoinCacheManager _coinCacheManager = locator<CoinCacheManager>();

  Timer? timer;

  List<MainCurrencyModel> tryCoins = [];
  List<MainCurrencyModel> btcCoins = [];
  List<MainCurrencyModel> ethCoins = [];
  List<MainCurrencyModel> usdtCoins = [];
  List<MainCurrencyModel> newCoins = [];
  int count = 0;

  List<MainCurrencyModel> coinListFromDb = [];

  Future<void> fetchAllCoins() async {
    emit(CoinListLoading());
    fetchDataTransactions();
    timer = Timer.periodic(const Duration(milliseconds: 5000), (Timer t) async {
      coinListFromDb = getAllListFromDB() ?? [];
      fetchDataTransactions();
    });
  }

  orderList(SortTypes type, List<MainCurrencyModel> list) {
    switch (type) {
      case SortTypes.NO_SORT:
        return list;
      case SortTypes.HIGH_TO_LOW_FOR_LAST_PRICE:
        // _orderByHighToLowForLastPrice(list);
        return _orderByHighToLowForLastPrice(list);
      case SortTypes.LOW_TO_HIGH_FOR_LAST_PRICE:
        return _orderByLowToHighForLastPrice(list);

      case SortTypes.HIGH_TO_LOW_FOR_PERCENTAGE:
        return _orderByHighToLowForPercentage(list);
      case SortTypes.LOW_TO_HIGH_FOR_PERCENTAGE:
        return _orderByLowToHighForPercentage(list);
      default:
        break;
    }
  }

  _orderByHighToLowForLastPrice(List<MainCurrencyModel> list) {
    list.sort((a, b) => double.parse(a.lastPrice ?? "0")
        .compareTo(double.parse(b.lastPrice ?? "0")));
    return list.reversed.toList();
  }

  _orderByLowToHighForLastPrice(List<MainCurrencyModel> list) {
    list.sort((a, b) => double.parse(a.lastPrice ?? "0")
        .compareTo(double.parse(b.lastPrice ?? "0")));
    return list;
  }

  _orderByHighToLowForPercentage(List<MainCurrencyModel> list) {
    list.sort((a, b) => double.parse(a.changeOf24H ?? "0")
        .compareTo(double.parse(b.changeOf24H ?? "0")));
    return list.reversed.toList();
  }

  _orderByLowToHighForPercentage(List<MainCurrencyModel> list) {
    list.sort((a, b) => double.parse(a.changeOf24H ?? "0")
        .compareTo(double.parse(b.changeOf24H ?? "0")));
    return list;
  }

  void fetchDataTransactions() {
    var responseTry = fetchTryCoinsFromGechoService();
    var responseUsd = fetchUsdtCoinsFromGechoService();
    var responseEth = fetchEthCoinsFromGechoService();
    var responseBtc = fetchBtcCoinsFromGechoService();
    var responseUsdNew = fetchUsdNewCoinsFromGechoService();
    var responseNftCollection = fetchNftCollectionsFromOpenSea();
    responseToListTransAction(tryCoins, responseTry);
    responseToListTransAction(usdtCoins, responseUsd);
    responseToListTransAction(ethCoins, responseEth);
    responseToListTransAction(btcCoins, responseBtc);
    //print("3333333333333333333333");
//
    //print(responseNftCollection.data!.length);

    if (responseNftCollection.data != null &&
        responseUsdNew.data != null &&
        responseNftCollection.data!.isNotEmpty) {
      // print("1111111111111111111111");
      responseUsdNew.data?.add(responseNftCollection.data![0]);
      responseToListTransAction(newCoins, responseUsdNew);
    } else {
//print("222222222222222");

      responseToListTransAction(newCoins, responseUsdNew);
    }
    // print(newCoins.length);
    count++;
    emit(CoinListCompleted(
        tryCoinsList: tryCoins,
        btcCoinsList: btcCoins,
        ethCoinsList: ethCoins,
        usdtCoinsList: usdtCoins,
        newUsdCoinsList: newCoins,
        count: count));
  }

  void responseToListTransAction(List<MainCurrencyModel> list,
      IResponseModel<List<MainCurrencyModel>> response) {
    list.clear();

    if (response.error != null) {
      emit(CoinListError("all list ERRRRRRRRRRRRORRRR"));
    }
    if (response.data != null) {
      for (var item in response.data!) {
        list.add(item);
        favoriteFeatureAndAlarmTransaction(coinListFromDb, list);
      }
      if (response.data!.isEmpty) {}
    }
  }

  IResponseModel<List<MainCurrencyModel>> fetchTryCoinsFromGechoService() {
    return GechoServiceController.instance.getGechoTryCoinList;
  }

  IResponseModel<List<MainCurrencyModel>> fetchUsdtCoinsFromGechoService() {
    return GechoServiceController.instance.getGechoUsdCoinList;
  }

  IResponseModel<List<MainCurrencyModel>> fetchBtcCoinsFromGechoService() {
    return GechoServiceController.instance.getGechoBtcCoinList;
  }

  IResponseModel<List<MainCurrencyModel>> fetchEthCoinsFromGechoService() {
    return GechoServiceController.instance.getGechoEthCoinList;
  }

  IResponseModel<List<MainCurrencyModel>> fetchUsdNewCoinsFromGechoService() {
    return GechoServiceController.instance.getNewGechoUsdCoinList;
  }

  IResponseModel<List<MainCurrencyModel>> fetchNftCollectionsFromOpenSea() {
    return OpenSeaServiceController.instance.getCollections;
  }

  void favoriteFeatureAndAlarmTransaction(
      List<MainCurrencyModel> incomingCoinListFromDb,
      List<MainCurrencyModel> incomingListFromService) {
    for (var itemFromDb in incomingCoinListFromDb) {
      for (var itemFromService in incomingListFromService) {
        if (itemFromDb.id == itemFromService.id) {
          itemFromService.isFavorite = itemFromDb.isFavorite;
          itemFromService.isAlarmActive = itemFromDb.isAlarmActive;
        }
      }
    }
  }

  void updateFromFavorites(MainCurrencyModel coin) {
    getFormDb(coin.id);
    if (coin.isFavorite) {
      coin.addedPrice = coin.lastPrice;
      _coinCacheManager.putItem(coin.id, coin);
    } else {
      if (coin.isAlarmActive) {
        coin.addedPrice = coin.lastPrice;

        _coinCacheManager.putItem(coin.id, coin);
      } else {
        _coinCacheManager.removeItem(coin.id);
      }
    }
  }

  MainCurrencyModel? getFormDb(String id) {
    return _coinCacheManager.getItem(id);
  }

  List<MainCurrencyModel>? getAllListFromDB() {
    return _coinCacheManager.getValues();
  }
}
