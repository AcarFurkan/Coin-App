import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import '../../../../../locator.dart';
import '../../../../../product/model/my_coin_model.dart';
import '../../../../../product/repository/cache/coin_cache_manager.dart';
import '../../../../../product/repository/service/market/gecho/gecho_service_controller.dart';

part 'coin_list_state.dart';

class CoinListCubit extends Cubit<CoinListState> {
  CoinListCubit() : super(CoinListInitial());
  CoinCacheManager _coinCacheManager = locator<CoinCacheManager>();

  Timer? timer;

  List<MainCurrencyModel> tryCoins = [];
  List<MainCurrencyModel> btcCoins = [];
  List<MainCurrencyModel> ethCoins = [];
  List<MainCurrencyModel> usdtCoins = [];
  List<MainCurrencyModel> newCoins = [];

  List<MainCurrencyModel> coinListFromDb = [];

  Future<void> fetchAllCoins() async {
    coinListFromDb = getAllListFromDB() ?? [];
    emit(CoinListLoading());
    tryCoins.clear();
    btcCoins.clear();
    ethCoins.clear();
    usdtCoins.clear();
    newCoins.clear();

    for (var item in fetchTryCoinsFromGechoService()) {
      tryCoins.add(item);
      favoriteFeatureAndAlarmTransaction(coinListFromDb, tryCoins);
    }
    for (var item in fetchUsdtCoinsFromGechoService()) {
      usdtCoins.add(item);
      favoriteFeatureAndAlarmTransaction(coinListFromDb, usdtCoins);
    }
    for (var item in fetchEthCoinsFromGechoService()) {
      ethCoins.add(item);
      favoriteFeatureAndAlarmTransaction(coinListFromDb, ethCoins);
    }
    for (var item in fetchBtcCoinsFromGechoService()) {
      btcCoins.add(item);
      favoriteFeatureAndAlarmTransaction(coinListFromDb, btcCoins);
    }
    for (var item in fetchUsdNewCoinsFromGechoService()) {
      newCoins.add(item);
      favoriteFeatureAndAlarmTransaction(coinListFromDb, btcCoins);
    }

    emit(CoinListCompleted(
        tryCoinsList: tryCoins,
        btcCoinsList: btcCoins,
        ethCoinsList: ethCoins,
        usdtCoinsList: usdtCoins,
        newUsdCoinsList: newCoins));
    timer = Timer.periodic(const Duration(milliseconds: 2000), (Timer t) async {
      tryCoins.clear();
      btcCoins.clear();
      ethCoins.clear();
      usdtCoins.clear();
      newCoins.clear();

      coinListFromDb = getAllListFromDB() ?? [];
      for (var item in fetchTryCoinsFromGechoService()) {
        tryCoins.add(item);
        favoriteFeatureAndAlarmTransaction(coinListFromDb, tryCoins);
      }
      for (var item in fetchUsdtCoinsFromGechoService()) {
        usdtCoins.add(item);
        favoriteFeatureAndAlarmTransaction(coinListFromDb, usdtCoins);
      }
      for (var item in fetchEthCoinsFromGechoService()) {
        ethCoins.add(item);
        favoriteFeatureAndAlarmTransaction(coinListFromDb, ethCoins);
      }
      for (var item in fetchBtcCoinsFromGechoService()) {
        btcCoins.add(item);
        favoriteFeatureAndAlarmTransaction(coinListFromDb, btcCoins);
      }
      for (var item in fetchUsdNewCoinsFromGechoService()) {
        newCoins.add(item);
        favoriteFeatureAndAlarmTransaction(coinListFromDb, btcCoins);
      }

      emit(CoinListCompleted(
          tryCoinsList: tryCoins,
          btcCoinsList: btcCoins,
          ethCoinsList: ethCoins,
          usdtCoinsList: usdtCoins,
          newUsdCoinsList: newCoins));
    });
  }

  List<MainCurrencyModel> fetchTryCoinsFromGechoService() {
    return GechoServiceController.instance.getGechoTryCoinList;
  }

  List<MainCurrencyModel> fetchUsdtCoinsFromGechoService() {
    return GechoServiceController.instance.getGechoUsdCoinList;
  }

  List<MainCurrencyModel> fetchBtcCoinsFromGechoService() {
    return GechoServiceController.instance.getGechoBtcCoinList;
  }

  List<MainCurrencyModel> fetchEthCoinsFromGechoService() {
    return GechoServiceController.instance.getGechoEthCoinList;
  }

  List<MainCurrencyModel> fetchUsdNewCoinsFromGechoService() {
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
