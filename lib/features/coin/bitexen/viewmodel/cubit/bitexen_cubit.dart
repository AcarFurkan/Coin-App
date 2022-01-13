import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:coin_with_architecture/core/model/response_model/IResponse_model.dart';
import 'package:meta/meta.dart';

import '../../../../../locator.dart';
import '../../../../../product/model/my_coin_model.dart';
import '../../../../../product/repository/cache/coin_cache_manager.dart';
import '../../../../../product/repository/service/market/bitexen/bitexen_service_controller.dart';

part 'bitexen_state.dart';

class BitexenCubit extends Cubit<BitexenState> {
  BitexenCubit() : super(BitexenInitial());
  CoinCacheManager _coinCacheManager = locator<CoinCacheManager>();

  Timer? timer;
  List<MainCurrencyModel> bitexenCoins = [];
  List<MainCurrencyModel> coinListFromDb = [];

  Future<void> fetchAllCoins() async {
    emit(BitexenLoading());
    dataTransaction();
    timer = Timer.periodic(const Duration(milliseconds: 2000), (Timer t) async {
      coinListFromDb = getAllListFromDB() ?? [];
      dataTransaction();
    });
  }

  void dataTransaction() {
    bitexenCoins.clear();
    var response = fetchBitexenCoinListFromService();
    if (response.error != null) {
      emit(BitexenError("Bitexen ERRRRRRRRRRRRORRRR"));
    }
    if (response.data != null) {
      for (var item in response.data!) {
        bitexenCoins.add(item);
        favoriteFeatureAndAlarmTransaction(coinListFromDb, bitexenCoins);
      }
      emit(BitexenCompleted(bitexenCoinsList: bitexenCoins));
    }
  }

  IResponseModel<List<MainCurrencyModel>> fetchBitexenCoinListFromService() {
    return BitexenServiceController.instance.getBitexenCoins;
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
