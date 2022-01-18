import 'package:bloc/bloc.dart';
import 'package:coin_with_architecture/product/model/coin/my_coin_model.dart';
import 'package:flutter/material.dart';

import '../../../../../../locator.dart';
import '../../../../../../product/repository/cache/coin_cache_manager.dart';
import '../../../../../settings/subpage/audio_settings/model/audio_model.dart';

part 'coin_detail_state.dart';

class CoinDetailCubit extends Cubit<CoinDetailState> {
  CoinDetailCubit() : super(CoinDetailInitial()) {
    isFavorite = false;
    isAlarm = false;
    isMinAlarmActive = false;
    isMaxAlarmActive = false;
    isMinLoop = false;
    isMaxLoop = false;
    minTextEditingController = TextEditingController();
    maxTextEditingController = TextEditingController();

    initilizeCacheManger();
  }
  late final TextEditingController minTextEditingController;
  late final TextEditingController maxTextEditingController;
  AudioModel? _minSelectedAudio;
  AudioModel? _maxSelectedAudio;

  late bool isFavorite;
  late bool isMinLoop;
  late bool isMaxLoop;
  late bool isAlarm;
  late bool isMinAlarmActive;
  late bool isMaxAlarmActive;
  late MainCurrencyModel inComingCoin;

  final CoinCacheManager _cacheManager = locator<CoinCacheManager>();
  MainCurrencyModel? myCoin;
  initilizeCacheManger() async {
    await _cacheManager.init();
  }

  changeIsFavorite() {
    emit(CoinDetailInitial());
    isFavorite = !isFavorite;
  }

  coinFavoriteActionUI(MainCurrencyModel coin) {
    changeIsFavorite();
    saveDeleteForFavorite(coin);
  }

  AudioModel? get minSelectedAudio {
    return _minSelectedAudio;
  }

  set minSelectedAudio(minSelectedAudio) {
    _minSelectedAudio = minSelectedAudio;
    emit(CoinDetailInitial());
  }

  get maxSelectedAudio {
    return _maxSelectedAudio;
  }

  set maxSelectedAudio(maxSelectedAudio) {
    _maxSelectedAudio = maxSelectedAudio;
    emit(CoinDetailInitial());
  }

  changeIsMinLoop() {
    emit(CoinDetailInitial());
    isMinLoop = !isMinLoop;
  }

  changeIsMaxLoop() {
    emit(CoinDetailInitial());
    isMaxLoop = !isMaxLoop;
  }

  changeIsMin() {
    emit(CoinDetailInitial());
    isMinAlarmActive = !isMinAlarmActive;
  }

  changeIsMax() {
    emit(CoinDetailInitial());
    isMaxAlarmActive = !isMaxAlarmActive;
  }

  changeIsAlarm() {
    emit(CoinDetailInitial());

    isAlarm = !isAlarm;
  }

  coinAlarmActionUI(MainCurrencyModel coin) {
    changeIsAlarm();
    saveDeleteForAlarm(coin);
  }

  setInComingCoin(MainCurrencyModel coin) {
    inComingCoin = coin;
  }

  getCoinByNameFromDb(String name) {
    var result = getFromDb(name);

    myCoin = result;
    if (result != null) {
      emit(CoinDetailInitial());

      isFavorite = result.isFavorite;
      isMinLoop = result.isMinLoop ?? false;
      isMaxLoop = result.isMaxLoop ?? false;
      isAlarm = result.isAlarmActive;
      isMaxAlarmActive = result.isMaxAlarmActive;
      isMinAlarmActive = result.isMinAlarmActive;
      minSelectedAudio = result.minAlarmAudio;
      maxSelectedAudio = result.maxAlarmAudio;
    } else {
      isFavorite = false;
      isAlarm = false;
      isMaxAlarmActive = false;
      isMinAlarmActive = false;
    }
  }

  Future<void> saveDeleteForAlarm(MainCurrencyModel incomingCoin) async {
    AudioModel? audioModel;
    if ((isAlarm == true && (isMinAlarmActive || isMaxAlarmActive)) &&
        (isFavorite == false || isFavorite == true)) {
      if (minSelectedAudio == null && isMinAlarmActive) {
        //             BUNLARI BURADAN AYIRMAK İÇİN ADD TO BE Yİ FAVORİ VE SET ALLARM OLARAK AYIRMALASIN HEM DAHA DOĞRU HEMDE BURDA İŞ SINIFLARINI ALIRSIN  !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        audioModel = AudioModel("audio1", "assets/audio/audio_one.mp3");
        minSelectedAudio = audioModel;
      }
      if (maxSelectedAudio == null && isMaxAlarmActive) {
        maxSelectedAudio =
            audioModel ?? AudioModel("audio1", "assets/audio/audio_one.mp3");
      }
      incomingCoin.isFavorite = true;
      incomingCoin.isAlarmActive = isAlarm;
      incomingCoin.isMinAlarmActive = isMinAlarmActive;
      incomingCoin.isMaxAlarmActive = isMaxAlarmActive;
      incomingCoin.isMinLoop = isMinLoop;
      incomingCoin.isMaxLoop = isMaxLoop;
      await addToDb(incomingCoin);
    } else if (isAlarm == false && isFavorite == true) {
      incomingCoin.isFavorite = true;
      incomingCoin.isAlarmActive = false;
      incomingCoin.isMinAlarmActive = false;
      incomingCoin.isMaxAlarmActive = false;
      incomingCoin.isMinLoop = false;
      incomingCoin.isMaxLoop = false;
      await addToDb(incomingCoin);
    } else if (isAlarm == false && isFavorite == false) {
      incomingCoin.isFavorite = false;
      incomingCoin.isAlarmActive = false;
      incomingCoin.isMinAlarmActive = false;
      incomingCoin.isMaxAlarmActive = false;
      incomingCoin.isMinLoop = false;
      incomingCoin.isMaxLoop = false;
      await removeFromDb(incomingCoin);
    }
  }

  Future<void> saveDeleteForFavorite(MainCurrencyModel incomingCoin) async {
    incomingCoin.isFavorite = isFavorite;
    if (isFavorite == true) {
      await addToDb(incomingCoin);
    } else {
      await removeFromDb(incomingCoin);
    }
  }

  Future<void> removeFromDb(MainCurrencyModel incomingCoin) async {
    _cacheManager.removeItem(incomingCoin.id);
  }

  Future<void> addToDb(MainCurrencyModel incomingCoin) async {
    await _cacheManager.putItem(
        incomingCoin.id,
        MainCurrencyModel(
          id: incomingCoin.id,
          name: incomingCoin.name,
          lastPrice: incomingCoin.lastPrice,
          isFavorite: incomingCoin.isFavorite,
          isAlarmActive: incomingCoin.isAlarmActive,
          isMinAlarmActive: incomingCoin.isMinAlarmActive,
          isMaxAlarmActive: incomingCoin.isMaxAlarmActive,
          counterCurrencyCode: incomingCoin.counterCurrencyCode,
          min: incomingCoin.min,
          max: incomingCoin.max,
          minAlarmAudio: minSelectedAudio,
          maxAlarmAudio: maxSelectedAudio,
          isMinLoop: incomingCoin.isMinLoop,
          isMaxLoop: incomingCoin.isMaxLoop,
        ));
  }

  MainCurrencyModel? getFromDb(String key) {
    MainCurrencyModel? coin = _cacheManager.getItem(key);

    return coin;
  }
}
