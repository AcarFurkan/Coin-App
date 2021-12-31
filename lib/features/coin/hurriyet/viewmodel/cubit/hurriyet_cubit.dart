import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:coin_with_architecture/product/model/my_coin_model.dart';
import 'package:coin_with_architecture/product/repository/cache/coin_cache_manager.dart';
import 'package:coin_with_architecture/product/repository/service/genelpara/genelpara_service.dart';
import 'package:coin_with_architecture/product/repository/service/genelpara/genepara_service_controller.dart';
import 'package:coin_with_architecture/product/repository/service/hurriyet/hurriyet_service_controller.dart';
import 'package:meta/meta.dart';

import '../../../../../locator.dart';

part 'hurriyet_state.dart';

class HurriyetCubit extends Cubit<HurriyetState> {
  HurriyetCubit() : super(HurriyetInitial());

  CoinCacheManager _coinCacheManager = locator<CoinCacheManager>();

  Timer? timer;
  List<MainCurrencyModel> hurriyetStockList = [];
  List<MainCurrencyModel> coinListFromDb = [];

  Future<void> fetchAllCoins() async {
    coinListFromDb = getAllListFromDB() ?? [];
    emit(HurriyetLoading());
    hurriyetStockList.clear();

    for (var item in fetchHurriyetStockListFromService()) {
      hurriyetStockList.add(item);
      favoriteFeatureAndAlarmTransaction(coinListFromDb, hurriyetStockList);
    }

    emit(HurriyetCompleted(
      hurriyetCoinsList: hurriyetStockList,
    ));
    timer = Timer.periodic(const Duration(milliseconds: 2000), (Timer t) async {
      hurriyetStockList.clear();
      coinListFromDb = getAllListFromDB() ?? [];
      for (var item in fetchHurriyetStockListFromService()) {
        hurriyetStockList.add(item);
        favoriteFeatureAndAlarmTransaction(coinListFromDb, hurriyetStockList);
      }

      emit(HurriyetCompleted(
        hurriyetCoinsList: hurriyetStockList,
      ));
    });
  }

  List<MainCurrencyModel> fetchHurriyetStockListFromService() {
    return HurriyetServiceController.instance.getHurriyetStocks;
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
