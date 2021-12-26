import 'dart:async';

import 'package:bloc/bloc.dart';
import '../../../../../product/repository/cache/coin_cache_manager.dart';
import '../../../../../locator.dart';
import '../../../../../product/viewmodel/service_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import '../../../../../product/model/my_coin_model.dart';

part 'coin_list_state.dart';

class CoinListCubit extends Cubit<CoinListState> {
  CoinListCubit() : super(CoinListInitial());
  ServiceViewModel _serviceViewModel = locator<ServiceViewModel>();
  CoinCacheManager _coinCacheManager = locator<CoinCacheManager>();

  Timer? timer;
  //bir eth kaç tl
  //bir usdt kaç tl
  //bir btc kaç tl
  //bir busd kaç tl   ??????

  late double ethTry;
  late double usdtTry;
  late double btcTry;
  //late double busdTry;
  List<MyCoin> allCoins = [];
  List<MyCoin> tryCoins = [];
  List<MyCoin> btcCoins = [];
  List<MyCoin> ethCoins = [];
  // List<MyCoin> busdCoins = [];
  List<MyCoin> usdtCoins = [];
  List<MyCoin> gechoUsdtCoins = [];
  List<MyCoin> coinListFromDb = [];

  /*bool isSearhOpen = false;

  changeIsSearch() {
    isSearhOpen = !isSearhOpen;
    print(isSearhOpen);
  }*/

  Future<void> fetchAllCoins() async {
    coinListFromDb = getAllListFromDB() ?? [];
    emit(CoinListLoading());
    tryCoins.clear();
    btcCoins.clear();
    ethCoins.clear();
    usdtCoins.clear();
    gechoUsdtCoins.clear();

    for (var item in fetchTryCoinsFromService()) {
      tryCoins.add(item);
      favoriteFeatureAndAlarmTransaction(coinListFromDb, tryCoins);
    }
    for (var item in fetchUsdtCoinsFromService()) {
      usdtCoins.add(item);
      favoriteFeatureAndAlarmTransaction(coinListFromDb, usdtCoins);
    }
    for (var item in fetchEthCoinsFromService()) {
      ethCoins.add(item);
      favoriteFeatureAndAlarmTransaction(coinListFromDb, ethCoins);
    }
    for (var item in fetchBtcCoinsFromService()) {
      btcCoins.add(item);
      favoriteFeatureAndAlarmTransaction(coinListFromDb, btcCoins);
    }
    var bb = fetchgechoCoinsFromService();
    for (var item in bb) {
      gechoUsdtCoins.add(item);
      favoriteFeatureAndAlarmTransaction(coinListFromDb, gechoUsdtCoins);
    }

    emit(CoinListCompleted(
        tryCoinsList: tryCoins,
        btcCoinsList: btcCoins,
        ethCoinsList: ethCoins,
        usdtCoinsList: usdtCoins,
        gechoCoinsList: gechoUsdtCoins));
    timer = Timer.periodic(const Duration(milliseconds: 2000), (Timer t) async {
      tryCoins.clear();
      btcCoins.clear();
      ethCoins.clear();
      usdtCoins.clear();
      gechoUsdtCoins.clear();
      coinListFromDb = getAllListFromDB() ?? [];
      for (var item in fetchTryCoinsFromService()) {
        tryCoins.add(item);
        favoriteFeatureAndAlarmTransaction(coinListFromDb, tryCoins);
      }
      for (var item in fetchUsdtCoinsFromService()) {
        usdtCoins.add(item);
        favoriteFeatureAndAlarmTransaction(coinListFromDb, usdtCoins);
      }
      for (var item in fetchEthCoinsFromService()) {
        ethCoins.add(item);
        favoriteFeatureAndAlarmTransaction(coinListFromDb, ethCoins);
      }
      for (var item in fetchBtcCoinsFromService()) {
        btcCoins.add(item);
        favoriteFeatureAndAlarmTransaction(coinListFromDb, btcCoins);
      }
      var cc = fetchgechoCoinsFromService();
      for (var item in cc) {
        gechoUsdtCoins.add(item);
        favoriteFeatureAndAlarmTransaction(coinListFromDb, gechoUsdtCoins);
      }

      emit(CoinListCompleted(
          tryCoinsList: tryCoins,
          btcCoinsList: btcCoins,
          ethCoinsList: ethCoins,
          usdtCoinsList: usdtCoins,
          gechoCoinsList: gechoUsdtCoins));
    });
  }

  List<MyCoin> fetchTryCoinsFromService() {
    return _serviceViewModel.getTryCoinList;
  }

  List<MyCoin> fetchUsdtCoinsFromService() {
    return _serviceViewModel.getUsdtCoinList;
  }

  List<MyCoin> fetchBtcCoinsFromService() {
    return _serviceViewModel.getBtcCoinList;
  }

  List<MyCoin> fetchEthCoinsFromService() {
    return _serviceViewModel.getEthCoinList;
  }

  List<MyCoin> fetchgechoCoinsFromService() {
    List<MyCoin> a = _serviceViewModel.getGechoUsdtCoinList;

    return a;
  }

  favoriteFeatureAndAlarmTransaction(List<MyCoin> incomingCoinListFromDb,
      List<MyCoin> incomingListFromService) {
    for (var itemFromDb in incomingCoinListFromDb) {
      for (var itemFromService in incomingListFromService) {
        if (itemFromDb.id == itemFromService.id) {
          itemFromService.isFavorite = itemFromDb.isFavorite;
          itemFromService.isAlarmActive = itemFromDb.isAlarmActive;
        }
      }
    }
  }

  updateFromFavorites(MyCoin coin) {
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

  MyCoin? getFormDb(String id) {
    return _coinCacheManager.getItem(id);
  }

  List<MyCoin>? getAllListFromDB() {
    return _coinCacheManager.getValues();
  }

  addToFavorite() {}
}
