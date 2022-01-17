import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../../../core/model/response_model/IResponse_model.dart';
import '../../../../../locator.dart';
import '../../../../../product/model/my_coin_model.dart';
import '../../../../../product/repository/cache/coin_cache_manager.dart';
import '../../../../../product/repository/service/market/truncgil/truncgil_service_controller.dart';

part 'truncgil_state.dart';

class TruncgilCubit extends Cubit<TruncgilState> {
  TruncgilCubit() : super(TruncgilInitial());
  final CoinCacheManager _coinCacheManager = locator<CoinCacheManager>();

  Timer? timer;
  List<MainCurrencyModel> truncgilList = [];
  List<MainCurrencyModel> coinListFromDb = [];

  Future<void> fetchAllCoins() async {
    emit(TruncgilLoading());
    dataTransaction();
    timer = Timer.periodic(const Duration(milliseconds: 2000), (Timer t) async {
      coinListFromDb = getAllListFromDB() ?? [];
      dataTransaction();
    });
  }

  void dataTransaction() {
    truncgilList.clear();
    var response = fetchTruncgilListFromService();
    if (response.error != null) {
      emit(TruncgilError("Truncgil ERRRRRRRRRRRRORRRR"));
    }
    if (response.data != null) {
      for (var item in response.data!) {
        truncgilList.add(item);
        favoriteFeatureAndAlarmTransaction(coinListFromDb, truncgilList);
      }
      emit(TruncgilCompleted(truncgilCoinsList: truncgilList));
    }
  }

  IResponseModel<List<MainCurrencyModel>> fetchTruncgilListFromService() {
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
