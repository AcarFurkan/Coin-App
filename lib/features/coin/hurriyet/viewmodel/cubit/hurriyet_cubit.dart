import 'dart:async';
import 'package:bloc/bloc.dart';
import '../../../../../core/model/response_model/IResponse_model.dart';
import 'package:meta/meta.dart';
import '../../../../../locator.dart';
import '../../../../../product/model/my_coin_model.dart';
import '../../../../../product/repository/cache/coin_cache_manager.dart';
import '../../../../../product/repository/service/market/genelpara/genepara_service_controller.dart';

part 'hurriyet_state.dart';

class HurriyetCubit extends Cubit<HurriyetState> {
  HurriyetCubit() : super(HurriyetInitial()) {
    _coinCacheManager = locator<CoinCacheManager>();
  }

  late final CoinCacheManager _coinCacheManager;

  Timer? timer;
  List<MainCurrencyModel> hurriyetStockList = [];
  List<MainCurrencyModel> coinListFromDb = [];

  Future<void> fetchAllCoins() async {
    coinListFromDb = getAllListFromDB() ?? [];
    emit(HurriyetLoading());
    dataTransaction();
    timer = Timer.periodic(const Duration(milliseconds: 2000), (Timer t) async {
      coinListFromDb = getAllListFromDB() ?? [];
      dataTransaction();
    });
  }

  IResponseModel<List<MainCurrencyModel>> fetchHurriyetStockListFromService() {
    return GenelParaServiceController.instance.getGenelParaStocks;
  }

  void dataTransaction() {
    hurriyetStockList.clear();
    var response = fetchHurriyetStockListFromService();
    if (response.error != null) {
      emit(HurriyetError("Hürriyet ERRRRRRRRRRRRORRRR"));
    }
    if (response.data != null) {
      for (var item in response.data!) {
        hurriyetStockList.add(item);
        favoriteFeatureAndAlarmTransaction(coinListFromDb, hurriyetStockList);
      }
      emit(HurriyetCompleted(hurriyetCoinsList: hurriyetStockList));
    }
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
