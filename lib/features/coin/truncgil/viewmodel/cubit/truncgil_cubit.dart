import 'dart:async';

import 'package:bloc/bloc.dart';
import '../../../../../product/model/my_coin_model.dart';
import '../../../../../product/repository/cache/coin_cache_manager.dart';
import '../../../../../product/repository/service/truncgil/truncgil_service_controller.dart';
import 'package:meta/meta.dart';

import '../../../../../locator.dart';

part 'truncgil_state.dart';

class TruncgilCubit extends Cubit<TruncgilState> {
  TruncgilCubit() : super(TruncgilInitial());
  CoinCacheManager _coinCacheManager = locator<CoinCacheManager>();

  Timer? timer;
  List<MainCurrencyModel> truncgilList = [];
  List<MainCurrencyModel> coinListFromDb = [];

  Future<void> fetchAllCoins() async {
    coinListFromDb = getAllListFromDB() ?? [];
    emit(TruncgilLoading());
    truncgilList.clear();

    for (var item in fetchBitexenCoinListFromService()) {
      truncgilList.add(item);
      favoriteFeatureAndAlarmTransaction(coinListFromDb, truncgilList);
    }

    emit(TruncgilCompleted(
      truncgilCoinsList: truncgilList,
    ));
    timer = Timer.periodic(const Duration(milliseconds: 2000), (Timer t) async {
      truncgilList.clear();
      coinListFromDb = getAllListFromDB() ?? [];
      for (var item in fetchBitexenCoinListFromService()) {
        truncgilList.add(item);
        favoriteFeatureAndAlarmTransaction(coinListFromDb, truncgilList);
      }

      emit(TruncgilCompleted(
        truncgilCoinsList: truncgilList,
      ));
    });
  }

  List<MainCurrencyModel> fetchBitexenCoinListFromService() {
    return TruncgilServiceController.instance.getTruncgilList;
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
