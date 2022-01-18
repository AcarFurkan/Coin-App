import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:coin_with_architecture/product/model/coin/my_coin_model.dart';
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

  List<MainCurrencyModel> coinListFromDb = [];

  Future<void> fetchAllCoins() async {
    emit(CoinListLoading());
    fetchDataTransactions();
    timer = Timer.periodic(const Duration(milliseconds: 2000), (Timer t) async {
      coinListFromDb = getAllListFromDB() ?? [];
      fetchDataTransactions();
    });
  }

  void fetchDataTransactions() {
    var responseTry = fetchTryCoinsFromGechoService();
    var responseUsd = fetchUsdtCoinsFromGechoService();
    var responseEth = fetchEthCoinsFromGechoService();
    var responseBtc = fetchBtcCoinsFromGechoService();
    var responseUsdNew = fetchUsdNewCoinsFromGechoService();
    responseToListTransAction(tryCoins, responseTry);
    responseToListTransAction(usdtCoins, responseUsd);
    responseToListTransAction(ethCoins, responseEth);
    responseToListTransAction(btcCoins, responseBtc);
    responseToListTransAction(newCoins, responseUsdNew);

    emit(CoinListCompleted(
        tryCoinsList: tryCoins,
        btcCoinsList: btcCoins,
        ethCoinsList: ethCoins,
        usdtCoinsList: usdtCoins,
        newUsdCoinsList: newCoins));
  }

  void responseToListTransAction(
      List<MainCurrencyModel> list, IResponseModel response) {
    list.clear();
    if (response.error != null) {
      emit(CoinListError("all list ERRRRRRRRRRRRORRRR"));
    }
    if (response.data != null) {
      for (var item in response.data!) {
        list.add(item);
        favoriteFeatureAndAlarmTransaction(coinListFromDb, list);
      }
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
      _coinCacheManager.putItem(coin.id, coin);
    } else {
      if (coin.isAlarmActive) {
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
