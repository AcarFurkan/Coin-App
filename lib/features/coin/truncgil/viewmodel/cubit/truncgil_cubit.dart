import 'dart:async';

import 'package:bloc/bloc.dart';
import '../../../selected_coin/viewmodel/cubit/coin_cubit.dart';
import '../../../../../product/model/coin/my_coin_model.dart';
import 'package:meta/meta.dart';

import '../../../../../core/model/response_model/IResponse_model.dart';
import '../../../../../locator.dart';
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
}
