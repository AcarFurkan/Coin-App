// ignore_for_file: constant_identifier_names

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:coin_with_architecture/core/enums/locale_keys_enum.dart';
import 'package:coin_with_architecture/core/extension/context_extension.dart';
import 'package:coin_with_architecture/product/alarm_manager/alarm_manager.dart';
import 'package:coin_with_architecture/product/language/locale_keys.g.dart';
import 'package:coin_with_architecture/product/repository/cache/app_cache_manager.dart';
import 'package:coin_with_architecture/product/repository/cache/coin_id_list_cache_manager.dart';
import 'package:coin_with_architecture/product/repository/service/market/gecho/gecho_service.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:provider/src/provider.dart';

import '../../../../../core/enums/back_up_enum.dart';
import '../../../../../core/model/error_model/base_error_model.dart';
import '../../../../../core/model/response_model/IResponse_model.dart';
import '../../../../../core/model/response_model/response_model.dart';
import '../../../../../locator.dart';
import '../../../../../product/model/coin/my_coin_model.dart';
import '../../../../../product/model/user/my_user_model.dart';
import '../../../../../product/repository/cache/coin_cache_manager.dart';
import '../../../../../product/repository/service/market/bitexen/bitexen_service_controller.dart';
import '../../../../../product/repository/service/market/gecho/gecho_service_controller.dart';
import '../../../../../product/repository/service/market/genelpara/genepara_service_controller.dart';
import '../../../../../product/repository/service/market/truncgil/truncgil_service_controller.dart';
import '../../../../../product/repository/service/user_service_controller/user_service_controller.dart';
import '../../../../authentication/viewmodel/cubit/user_cubit.dart';
import '../../../../settings/subpage/audio_settings/model/audio_model.dart';

part 'coin_state.dart';

enum levelControl { INCREASING, DESCREASING, CONSTANT }
enum SortTypes {
  NO_SORT,
  HIGH_TO_LOW_FOR_LAST_PRICE,
  LOW_TO_HIGH_FOR_LAST_PRICE,
  HIGH_TO_LOW_FOR_PERCENTAGE,
  LOW_TO_HIGH_FOR_PERCENTAGE,
  HIGH_TO_LOW_FOR_ADDED_PRICE,
  LOW_TO_HIGH_FOR_ADDED_PRICE,
}

class CoinCubit extends Cubit<CoinState> {
  CoinCubit({required this.context}) : super(CoinInitial());
  BuildContext context;
  final CoinCacheManager _cacheManager = locator<CoinCacheManager>();
  List<String>? _itemsToBeDelete;
  List<String>? get itemsToBeDelete => _itemsToBeDelete;
  // AudioPlayer? player;
  final UserServiceController _userServiceController =
      UserServiceController.instance;
  final CoinIdListCacheManager _coinIdListCacheManager =
      locator<CoinIdListCacheManager>();
  final AppCacheManager _appCacheManager = locator<AppCacheManager>();

  Timer? timer;
  Color textColor = Colors.black;
  Future<void> startCompare() async {
    timer ??= Timer.periodic(const Duration(seconds: 2), (Timer t) async {
      var result = await compareCoins();
      if (result.isEmpty) {
        emit(CoinInitial());
      }
      emit(CoinCompleted(result));
    });
  }

  Future<List<MainCurrencyModel>> compareCoins() async {
    IResponseModel<List<MainCurrencyModel>> currencyServiceResponse =
        fetchAllCoinsFromService();

    List<MainCurrencyModel>? coinListFromDataBase =
        _fetchAllAddedCoinsFromDatabase();

    MyUser? myUser = context.read<UserCubit>().user;

    if (coinListFromDataBase == null) {
      return [];
    }
    allCoinIdListBackUpCheck();
    await backUpCheck(myUser, coinListFromDataBase); // YOU CAN DELETE THESE

    if (currencyServiceResponse.error != null) {
      emit(CoinError("general error"));
    }
    if (currencyServiceResponse.data != null) {
      dataFullTransactions(coinListFromDataBase, currencyServiceResponse.data!);
    }

    calculatePercentageDifferencesSinceAddedTime(coinListFromDataBase);

    return coinListFromDataBase;
  }

  calculatePercentageDifferencesSinceAddedTime(List<MainCurrencyModel> list) {
    for (var item in list) {
      double addedPrice = double.parse(item.addedPrice ?? "0");
      double lastPrice = double.parse(item.lastPrice ?? "0");
      double difference = lastPrice - addedPrice;
      if (item.id == "binancecoingechoUSD") {
        print(((difference / addedPrice) * 100));
      }
      item.changeOfPercentageSincesAddedTime =
          ((difference / addedPrice) * 100).toString();
    }
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
      case SortTypes.HIGH_TO_LOW_FOR_ADDED_PRICE:
        return _orderByHighToLowForAddedPrice(list);
      case SortTypes.LOW_TO_HIGH_FOR_ADDED_PRICE:
        return _orderByLowToHighForAddedPrice(list);
      case SortTypes.HIGH_TO_LOW_FOR_PERCENTAGE:
        return _orderByHighToLowForPercentage(list);
      case SortTypes.LOW_TO_HIGH_FOR_PERCENTAGE:
        return _orderByLowToHighForPercentage(list);
      default:
        break;
    }
  }

  _orderByHighToLowForAddedPrice(List<MainCurrencyModel> list) {
    list.sort((a, b) => double.parse(a.addedPrice ?? "0")
        .compareTo(double.parse(b.addedPrice ?? "0")));
    return list.reversed.toList();
  }

  _orderByLowToHighForAddedPrice(List<MainCurrencyModel> list) {
    list.sort((a, b) => double.parse(a.addedPrice ?? "0")
        .compareTo(double.parse(b.addedPrice ?? "0")));
    return list;
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

  void dataFullTransactions(List<MainCurrencyModel> coinListFromDataBase,
      List<MainCurrencyModel> coinListFromService) {
    for (var i = 0; i < coinListFromService.length; i++) {
      for (var itemFromDataBase in coinListFromDataBase) {
        if (coinListFromService[i].id == itemFromDataBase.id) {
          MainCurrencyModel currentSeviceItem = coinListFromService[i];
          double lastPrice = double.parse(currentSeviceItem.lastPrice ?? "0");
          arrangeCurrencyByInComingValue(itemFromDataBase, currentSeviceItem);
          alarmControl(lastPrice, itemFromDataBase);
        }
      }
    }
  }

  void alarmControl(double lastPrice, MainCurrencyModel itemFromDataBase) {
    if (lastPrice < itemFromDataBase.min && itemFromDataBase.isMinAlarmActive) {
      playMusic(
          itemFromDataBase.minAlarmAudio ??
              AudioModel(
                "audio1",
                "assets/audio/sweet_alarm.mp3",
              ),
          itemFromDataBase.isMinLoop!,
          title: LocaleKeys.alarmAlertDialog_min.tr());
      itemFromDataBase.isMinAlarmActive = false;
      if (itemFromDataBase.isMaxAlarmActive == false) {
        itemFromDataBase.isAlarmActive = false;
      }
      addToDb(itemFromDataBase);
      emit(CoinAlarm(
          itemFromDataBase: itemFromDataBase,
          message:
              "${itemFromDataBase.name.toUpperCase()} ${LocaleKeys.alarmAlertDialog_min.tr()}"));
    } else if (lastPrice > itemFromDataBase.max &&
        itemFromDataBase.isMaxAlarmActive &&
        itemFromDataBase.max != 0) {
      playMusic(
          itemFromDataBase.maxAlarmAudio ??
              AudioModel("audio1", "assets/audio/sweet_alarm.mp3"),
          itemFromDataBase.isMaxLoop!,
          title:
              "${itemFromDataBase.name.toUpperCase()} ${LocaleKeys.alarmAlertDialog_max.tr()}");
      itemFromDataBase.isMaxAlarmActive = false;
      if (itemFromDataBase.isMinAlarmActive == false) {
        itemFromDataBase.isAlarmActive = false;
      }
      addToDb(itemFromDataBase);
      emit(CoinAlarm(
          itemFromDataBase: itemFromDataBase,
          message:
              "${itemFromDataBase.name.toUpperCase()} ${LocaleKeys.alarmAlertDialog_max.tr()}"));
    }
  }

  void arrangeCurrencyByInComingValue(
      MainCurrencyModel itemFromDataBase, MainCurrencyModel currentSeviceItem) {
    itemFromDataBase.changeOf24H = currentSeviceItem.changeOf24H ?? "0";

    itemFromDataBase.lastUpdate = currentSeviceItem.lastUpdate;
    itemFromDataBase.percentageControl = currentSeviceItem.percentageControl;
    itemFromDataBase.priceControl = currentSeviceItem.priceControl;
    itemFromDataBase.lastPrice = currentSeviceItem.lastPrice ?? "0";
    itemFromDataBase.highOf24h = currentSeviceItem.highOf24h ?? "0";
    itemFromDataBase.lowOf24h = currentSeviceItem.lowOf24h ?? "0";
  }

  void allCoinIdListBackUpCheck() {
    //_appCacheManager.putItem(PreferencesKeys.ID_LIST_LAST_UPDATE.name,
    //    DateTime(2020, 1, 1).toString());
    String? date =
        _appCacheManager.getItem(PreferencesKeys.ID_LIST_LAST_UPDATE.name);
    if (date != null) {
      DateTime lastUpdate = DateTime.parse(date);
      DateTime now = DateTime.now();
      //print((now.millisecondsSinceEpoch - lastUpdate.millisecondsSinceEpoch) ~/
      //    (1000 * 60));
      int difference =
          (now.millisecondsSinceEpoch - lastUpdate.millisecondsSinceEpoch) ~/
              (1000 * 60 * 60 * 24);
      if ((difference) >= 1) {
        print("DAİLY YEDEKLEMEYE GİRİLDİ");
        _appCacheManager.putItem(PreferencesKeys.ID_LIST_LAST_UPDATE.name,
            DateTime.now().toString());
        updateCoinIdList();
      }
    } else {
      print("NULL A GİRDİK");
      updateCoinIdList();
      _appCacheManager.putItem(
          PreferencesKeys.ID_LIST_LAST_UPDATE.name, DateTime.now().toString());
    }
  }

  Future<void> updateCoinIdList() async {
    //TODO: HATA YÖNETİMİ FİLAN HAK GETİRE
    Map mapFromService = await GechoService.instance.getAllCoinsIdList();
    print(mapFromService.length);
    _coinIdListCacheManager.clearAll();
    _coinIdListCacheManager.addItems(mapFromService);
  }

  Future<void> backUpCheck(
      MyUser? myUser, List<MainCurrencyModel> coinListFromDataBase) async {
    if (context.read<UserCubit>().user != null &&
        context.read<UserCubit>().user?.isBackUpActive == true) {
      if (context.read<UserCubit>().user!.updatedAt != null) {
        int day = ((DateTime.now().millisecondsSinceEpoch) -
                context
                    .read<UserCubit>()
                    .user!
                    .updatedAt!
                    .millisecondsSinceEpoch) ~/
            (1000 * 60 * 60 * 24);
        if (myUser!.backUpType == BackUpTypes.daily.name) {
          if (day >= 1) {
            await _userServiceController.updateUserCurrenciesInformation(
                context.read<UserCubit>().user!,
                listCurrency: coinListFromDataBase);
            await context.read<UserCubit>().getCurrentUser();
          }
        } else if (myUser.backUpType == BackUpTypes.weekly.name) {
          if (day >= 7) {
            await _userServiceController.updateUserCurrenciesInformation(
                context.read<UserCubit>().user!,
                listCurrency: coinListFromDataBase);
            await context.read<UserCubit>().getCurrentUser();
          }
        } else if (myUser.backUpType == BackUpTypes.monthly.name) {
          if (day >= 30) {
            await _userServiceController.updateUserCurrenciesInformation(
                context.read<UserCubit>().user!,
                listCurrency: coinListFromDataBase);
            await context.read<UserCubit>().getCurrentUser();
          }
        }
      }
    } else if (context.read<UserCubit>().user !=
            null && // YOU CAN DELETE THESE"1
        context.read<UserCubit>().user?.isBackUpActive == false) {
      // YOU CAN DELETE THESE
    } else if (context.read<UserCubit>().user ==
        null) {} // YOU CAN DELETE THESE
  }

  saveDeleteFromFavorites(MainCurrencyModel coin) {
    _cacheManager.getItem(coin.id);
    if (coin.isFavorite) {
      _cacheManager.putItem(coin.id, coin);
    } else {
      if (coin.isAlarmActive) {
        _cacheManager.putItem(coin.id, coin);
      } else {
        _cacheManager.removeItem(coin.id);
      }
    }
  }

  Future<void> addToDb(MainCurrencyModel incomingCoin) async {
    await _cacheManager.putItem(incomingCoin.id, incomingCoin);
  }

  startAgain() {
    startCompareAgain();
  }

  updatePage({bool isSelected = false}) {
    if (timer != null) {
      timer!.cancel();
      timer = null;
    }

    emit(UpdateSelectedCoinPage(isSelected, _fetchAllAddedCoinsFromDatabase()));
  }

  Future<void> startCompareAgain() async {
    emit(CoinLoading());
    timer ??= Timer.periodic(const Duration(seconds: 1), (Timer t) async {
      var result = await compareCoins();
      if (result.isEmpty) {
        emit(CoinInitial());
      }
      emit(CoinCompleted(result));
    });
  }

  addItemToBeDeletedList(String id) {
    _itemsToBeDelete ??= [];
    for (var item in _itemsToBeDelete!) {
      if (item == id) {
        return;
      }
    }
    _itemsToBeDelete!.add(id);
  }

  removeItemFromBeDeletedList(String id) {
    _itemsToBeDelete ??= [];
    for (var item in _itemsToBeDelete!) {
      if (item == id) {
        _itemsToBeDelete!.remove(id);
        return;
      }
    }
  }

  deleteItemsFromDb() {
    if (_itemsToBeDelete != null) {
      //_cacheManager.clearAll();  send a value like if  isselectedAll true and run it
      List<MainCurrencyModel>? list = _fetchAllAddedCoinsFromDatabase();

      if (list!.length == _itemsToBeDelete!.length) {
        _cacheManager.clearAll();
        clearAllItemsFromToDeletedList();
        return;
      }
      for (var item in _itemsToBeDelete!) {
        _cacheManager.removeItem(item);
      }
      clearAllItemsFromToDeletedList();
    }
  }

  clearAllItemsFromToDeletedList() {
    if (_itemsToBeDelete != null) {
      _itemsToBeDelete!.clear();
    }
  }

  List<MainCurrencyModel>? _fetchAllAddedCoinsFromDatabase() {
    return _cacheManager.getValues();
  }

  IResponseModel<List<MainCurrencyModel>> fetchAllCoinsFromService() {
    IResponseModel<List<MainCurrencyModel>> allResponse =
        ResponseModel(data: []);

    var resposneTryGecho = fetchTryCoinsFromGechoService();
    var resposneUsdGecho = fetchUsdtCoinsFromGechoService();
    var resposneBtcGecho = fetchBtcCoinsFromGechoService();
    var resposneEthGecho = fetchEthCoinsFromGechoService();
    var resposneBitexen = fetchAllCoinsFromBitexen();
    var resposneTruncgil = fetchTruncgilService();
    var responseNewUsdGecho = fetchUsdNewCoinsFromGechoService();

    if (resposneTryGecho.error != null ||
        resposneUsdGecho.error != null ||
        resposneBtcGecho.error != null ||
        resposneEthGecho.error != null ||
        resposneBitexen.error != null ||
        resposneTruncgil.error != null ||
        responseNewUsdGecho.error != null) {
      allResponse.error = BaseError(message: "error");
    }
    if (resposneTryGecho.data != null) {
      allResponse.data?.addAll(resposneTryGecho.data!);
    }
    if (resposneUsdGecho.data != null) {
      allResponse.data?.addAll(resposneUsdGecho.data!);
    }
    if (resposneBtcGecho.data != null) {
      allResponse.data?.addAll(resposneBtcGecho.data!);
    }
    if (resposneEthGecho.data != null) {
      allResponse.data?.addAll(resposneEthGecho.data!);
    }
    if (resposneBitexen.data != null) {
      allResponse.data?.addAll(resposneBitexen.data!);
    }
    if (resposneTruncgil.data != null) {
      allResponse.data?.addAll(resposneTruncgil.data!);
    }
    if (responseNewUsdGecho.data != null) {
      allResponse.data?.addAll(responseNewUsdGecho.data!);
    }

    return allResponse;
  }

  IResponseModel<List<MainCurrencyModel>> fetchTruncgilService() {
    return TruncgilServiceController.instance.getTruncgilList;
  }

  IResponseModel<List<MainCurrencyModel>> fetchGenelParaService() {
    return GenelParaServiceController.instance.getGenelParaStocks;
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

  IResponseModel<List<MainCurrencyModel>> fetchAllCoinsFromBitexen() {
    return BitexenServiceController.instance.getBitexenCoins;
  }

  IResponseModel<List<MainCurrencyModel>> fetchUsdNewCoinsFromGechoService() {
    return GechoServiceController.instance.getNewGechoUsdCoinList;
  }

  void stopAudio() {
    AudioManager.instance.stop();
    //    AudioManager.instance.stop();
  }

  Future<void> playMusic(AudioModel audioModel, bool isLoop,
      {required String title}) async {
    //TODO: CHANGE TRY CACHE METHOD YOU MANAGE IT FROM AUDIOMANAGER

    if (audioModel.name == "vibration") {
      final Iterable<Duration> pauses = [
        const Duration(milliseconds: 500),
        const Duration(milliseconds: 1000),
        const Duration(milliseconds: 500),
        const Duration(milliseconds: 1000),
        const Duration(milliseconds: 500),
        const Duration(milliseconds: 1000),
        const Duration(milliseconds: 500),
        const Duration(milliseconds: 1000),
        const Duration(milliseconds: 500),
      ];
      Vibrate.vibrateWithPauses(pauses);
      AudioManager.instance.play(
        audioModel,
        isLoop: isLoop,
        title: title,
        time: context.ultraHighDuration.inSeconds * 2,
      );
    } else {
      try {
        if (isLoop) {
          AudioManager.instance.play(audioModel, isLoop: isLoop, title: title);
        } else {
          AudioManager.instance.play(audioModel,
              isLoop: isLoop,
              time: context.ultraHighDuration.inSeconds * 2,
              title: title);
        }
      } catch (e) {
        print(e);
      }
    }
  }
}
