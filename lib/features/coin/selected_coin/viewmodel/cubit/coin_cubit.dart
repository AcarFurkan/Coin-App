import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:coin_with_architecture/core/model/error_model/IError_model.dart';
import 'package:coin_with_architecture/core/model/error_model/base_error_model.dart';
import 'package:coin_with_architecture/core/model/response_model/IResponse_model.dart';
import 'package:coin_with_architecture/core/model/response_model/response_model.dart';
import '../../../../../core/enums/back_up_enum.dart';
import '../../../../authentication/viewmodel/cubit/user_cubit.dart';
import '../../../../../product/model/user/my_user_model.dart';
import '../../../../../product/repository/service/market/genelpara/genepara_service_controller.dart';
import '../../../../../product/repository/service/user_service_controller/user_service_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

import 'package:provider/src/provider.dart';

import '../../../../../locator.dart';
import '../../../../../product/model/my_coin_model.dart';
import '../../../../../product/repository/cache/coin_cache_manager.dart';
import '../../../../../product/repository/service/market/bitexen/bitexen_service_controller.dart';
import '../../../../../product/repository/service/market/gecho/gecho_service_controller.dart';
import '../../../../../product/repository/service/market/truncgil/truncgil_service_controller.dart';
import '../../../../settings/subpage/audio_settings/model/audio_model.dart';

part 'coin_state.dart';

enum levelControl { INCREASING, DESCREASING, CONSTANT }

class CoinCubit extends Cubit<CoinState> {
  CoinCubit({required this.context}) : super(CoinInitial()) {}
  BuildContext context;
  final CoinCacheManager _cacheManager = locator<CoinCacheManager>();
  List<String>? _itemsToBeDelete;
  List<String>? get itemsToBeDelete => _itemsToBeDelete;
  AudioPlayer? player;
  final UserServiceController _userServiceController =
      UserServiceController.instance;

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
    if (context.read<UserCubit>().user != null &&
        context.read<UserCubit>().user?.isBackUpActive == true) {
      if (context.read<UserCubit>().user!.updatedAt != null) {
        print(context.read<UserCubit>().user!.updatedAt!);
        print(DateTime.now());

        int day = ((DateTime.now().millisecondsSinceEpoch) -
                context
                    .read<UserCubit>()
                    .user!
                    .updatedAt!
                    .millisecondsSinceEpoch) ~/
            (1000 * 60 * 60 * 24);
        print(day);
        if (myUser!.backUpType == BackUpTypes.daily.name) {
          print(context.read<UserCubit>().user!.backUpType!);

          if (day >= 1) {
            await _userServiceController.updateUserCurrenciesInformation(
                context.read<UserCubit>().user!,
                listCurrency: coinListFromDataBase);
            await context.read<UserCubit>().getCurrentUser();
          }
        } else if (myUser.backUpType == BackUpTypes.weekly.name) {
          print(context.read<UserCubit>().user!.backUpType!);
          if (day >= 7) {
            await _userServiceController.updateUserCurrenciesInformation(
                context.read<UserCubit>().user!,
                listCurrency: coinListFromDataBase);
            await context.read<UserCubit>().getCurrentUser();
          }
        } else if (myUser.backUpType == BackUpTypes.monthly.name) {
          print(context.read<UserCubit>().user!.backUpType!);

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
    if (currencyServiceResponse.error != null) {
      emit(CoinError("general error"));
    } else if (currencyServiceResponse.data != null) {
      for (var i = 0; i < currencyServiceResponse.data!.length; i++) {
        for (var itemFromDataBase in coinListFromDataBase) {
          if (currencyServiceResponse.data![i].id == itemFromDataBase.id) {
            double doubleParse =
                double.parse(currencyServiceResponse.data![i].lastPrice ?? "0");
            double changeOf24H = double.parse(
                currencyServiceResponse.data![i].changeOf24H ?? "0");

            itemFromDataBase.percentageControl =
                currencyServiceResponse.data![i].percentageControl;
            itemFromDataBase.priceControl =
                currencyServiceResponse.data![i].priceControl;
            itemFromDataBase.lastPrice = currencyServiceResponse
                    .data![i].lastPrice ??
                "0"; ////Bunları değiştiriyosun da data base hiçbiri gitmiyo galiba tam anlamadım gitmemesi lazım ama okadar değişikliği nasıl algılıyo
            itemFromDataBase.changeOf24H = changeOf24H.toString();
            itemFromDataBase.highOf24h =
                currencyServiceResponse.data![i].highOf24h ?? "0";
            itemFromDataBase.lowOf24h =
                currencyServiceResponse.data![i].lowOf24h ?? "0";

            if (doubleParse < itemFromDataBase.min &&
                itemFromDataBase.isMinAlarmActive) {
              //playMusic(itemFromDataBase.minAlarmAudio!,"Minumum fiyatının altına düştü");

              playMusic(
                  itemFromDataBase.minAlarmAudio ??
                      AudioModel("audio1", "assets/audio/audio_one.mp3"),
                  itemFromDataBase.isMinLoop!);
              itemFromDataBase.isMinAlarmActive = false;
              addToDb(itemFromDataBase);

              showAlertDialog(
                  itemFromDataBase, " fiyat minimum fiyatın altına indi.");

              // playMusic();
            }
            if (doubleParse > itemFromDataBase.max &&
                itemFromDataBase.isMaxAlarmActive &&
                itemFromDataBase.max != 0) {
              /* playMusic(itemFromDataBase.maxAlarmAudio!,
                "Maximum fiyatının üstüne çıktı");*/

              playMusic(
                  itemFromDataBase.maxAlarmAudio ??
                      AudioModel("audio1", "assets/audio/audio_one.mp3"),
                  itemFromDataBase.isMaxLoop!);
              itemFromDataBase.isMaxAlarmActive = false;
              addToDb(itemFromDataBase);
              showAlertDialog(
                  itemFromDataBase, " fiyat maximum fiyatın üzerine çıktı");

              //playMusic();
            }
          }
        }
      }
    }

    return coinListFromDataBase;
  }

  showAlertDialog(MainCurrencyModel coin, String message) {
    showDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text(coin.name + message),
            actions: [
              CupertinoDialogAction(
                child: const Text("Stop"),
                onPressed: () async {
                  stopMusic();
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
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

    if (resposneTryGecho.error != null ||
        resposneUsdGecho.error != null ||
        resposneBtcGecho.error != null ||
        resposneEthGecho.error != null ||
        resposneBitexen.error != null ||
        resposneTruncgil.error != null) {
      allResponse.error = BaseError(message: "error");
    }
    allResponse.data?.addAll(resposneTryGecho.data!);
    allResponse.data?.addAll(resposneUsdGecho.data!);
    allResponse.data?.addAll(resposneBtcGecho.data!);
    allResponse.data?.addAll(resposneEthGecho.data!);
    allResponse.data?.addAll(resposneBitexen.data!);
    allResponse.data?.addAll(resposneTruncgil.data!);
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

  stopMusic() async {
    await player!.pause();
    await player!.seek(Duration.zero);
  }

  Future<void> playMusic(AudioModel audioModel, bool isLoop) async {
    player ??= AudioPlayer();

    try {
      // await player.setAsset('assets/audio/ozcan2.mp3');
      if (Platform.isWindows) {
        await player!.setAsset((audioModel.path));
        // player!.play();
        player!.seek(Duration(seconds: 20));
      } else {
        await player!.setAsset(audioModel.path);
        await player!
            .setClip(start: Duration(seconds: 0), end: Duration(seconds: 10));
      }

      if (!isLoop) {
        player!.play();
      } else {
        player!.setLoopMode(LoopMode.one);

        player!.play();
      }
    } on PlayerException catch (e) {
      print("Error code: ${e.code}");

      print("Error message: ${e.message}");
    } on PlayerInterruptedException catch (e) {
      print("Connection aborted: ${e.message}");
    } catch (e) {
      print("--------------------------");

      print(e);
    }
  }

  Future<void> demo() async {
    /* player!.streams.medias.listen((List<Media> medias) {});
    player.streams.isPlaying.listen((bool isPlaying) {});
    player.streams.isBuffering.listen((bool isBuffering) {});
    player.streams.isCompleted.listen((bool isCompleted) {});
    player.streams.position.listen((Duration position) {});
    player.streams.duration.listen((Duration duration) {});
    player.streams.index.listen((int index) {});
    player.open([
      Media(
          uri: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3'),
    ]);*/
  }
/*
  void demo() {
  var player = Player(id: 0);
  player.streams.medias.listen((List<Media> medias) {});
  player.streams.isPlaying.listen((bool isPlaying) {});
  player.streams.isBuffering.listen((bool isBuffering) {});
  player.streams.isCompleted.listen((bool isCompleted) {});
  player.streams.position.listen((Duration position) {});
  player.streams.duration.listen((Duration duration) {});
  player.streams.index.listen((int index) {});
  player.open([
    Media(uri: 'https://www.example.com/media/music.mp3'),
    Media(uri: 'file://C:/documents/video.mp4'),
  ]);
  player.play();
  player.seek(Duration(seconds: 20));
  player.nativeControls.update(
    album: 'Fine Line',
    albumArtist: 'Harry Styles',
    trackCount: 12,
    artist: 'Harry Styles',
    title: 'Lights Up',
    trackNumber: 1,
    thumbnail: File('album_art.png'),
  );
}*/

  /*Future<void> playMusic2(AudioModel audioModel, String title) async {
    AudioManager.instance
        .start(
            audioModel.path,
            // "network format resource"
            // "local resource (file://${file.path})"
            title,
            desc: audioModel.name,
            // cover: "network cover image resource"
            cover: "assets/laimg.jpeg")
        .then((err) {
      //print(err);
    });
  }*/

  /*AudioManager.instance
        .start(
            "assets/alperen.mp3",
            // "network format resource"
            // "local resource (file://${file.path})"
            "SAATTTTTTTTT",
            desc: "SAAAAAAATTTT",
            // cover: "network cover image resource"
            cover: "assets/laimg.jpeg")
        .then((err) {
      //print(err);
    });*/
}
