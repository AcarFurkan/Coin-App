import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import '../../../../settings/audio_settings/model/audio_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:just_audio/just_audio.dart';
import '../../../../../product/viewmodel/service_viewmodel.dart';
import 'package:flutter/material.dart';
import '../../../../../product/model/my_coin_model.dart';
import '../../../../../product/repository/cache/coin_cache_manager.dart';

import '../../../../../locator.dart';

part 'coin_state.dart';

enum levelControl { INCREASING, DESCREASING, CONSTANT }

class CoinCubit extends Cubit<CoinState> {
  CoinCubit({required this.context}) : super(CoinInitial()) {}
  BuildContext context;
  final CoinCacheManager _cacheManager = locator<CoinCacheManager>();
  final ServiceViewModel _serviceViewModel = locator<ServiceViewModel>();
  List<String>? _itemsToBeDelete;
  List<String>? get itemsToBeDelete => _itemsToBeDelete;
  AudioPlayer? player;

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

  Future<List<MyCoin>> compareCoins() async {
    List<MyCoin> coinListFromService = fetchAllCoinsFromService();

    List<MyCoin>? coinListFromDataBase = _fetchAllAddedCoinsFromDatabase();

    if (coinListFromDataBase == null) {
      return [];
    }
    for (var i = 0; i < coinListFromService.length; i++) {
      for (var itemFromDataBase in coinListFromDataBase) {
        if (coinListFromService[i].id == itemFromDataBase.id) {
          double doubleParse =
              double.parse(coinListFromService[i].lastPrice ?? "0");
          double changeOf24H =
              double.parse(coinListFromService[i].changeOf24H ?? "0");

          itemFromDataBase.percentageControl =
              coinListFromService[i].percentageControl;
          itemFromDataBase.priceControl = coinListFromService[i].priceControl;
          itemFromDataBase.lastPrice = coinListFromService[i].lastPrice ??
              "0"; ////Bunları değiştiriyosun da data base hiçbiri gitmiyo galiba tam anlamadım gitmemesi lazım ama okadar değişikliği nasıl algılıyo
          itemFromDataBase.changeOf24H =
              coinListFromService[i].changeOf24H ?? "0";
          itemFromDataBase.highOf24h = coinListFromService[i].highOf24h ?? "0";
          itemFromDataBase.lowOf24h = coinListFromService[i].lowOf24h ?? "0";

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
    return coinListFromDataBase;
  }

  showAlertDialog(MyCoin coin, String message) {
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

  saveDeleteFromFavorites(MyCoin coin) {
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

  Future<void> addToDb(MyCoin incomingCoin) async {
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
    // sadece ID OLARAK DA GUNCELLEYE BİLİRSİN BUNU BİR DÜŞÜN
    //  probably you can deletejusty with id think that..
    _itemsToBeDelete ??= [];
    for (var item in _itemsToBeDelete!) {
      if (item == id) {
        return;
      }
    }

    _itemsToBeDelete!.add(id);
  }

  printDeletedItemList() {
    if (_itemsToBeDelete != null) {
      if (_itemsToBeDelete!.isEmpty) {
        return;
      }
      for (var item in _itemsToBeDelete!) {}
    } else if (_itemsToBeDelete == []) {
    } else {}
  }

  removeItemFromBeDeletedList(String id) {
    // sadece ID OLARAK DA GUNCELLEYE BİLİRSİN BUNU BİR DÜŞÜN
    //  probably you can deletejusty with id think that..

    _itemsToBeDelete ??= [];
    for (var item in _itemsToBeDelete!) {
      if (item == id) {
        printDeletedItemList();
        _itemsToBeDelete!.remove(id);
        printDeletedItemList();
        return;
      }
    }
  }

  deleteItemsFromDb() {
    if (_itemsToBeDelete != null) {
      //_cacheManager.clearAll();  send a value like if  isselectedAll true and run it
      List<MyCoin>? list = _fetchAllAddedCoinsFromDatabase();

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

  List<MyCoin>? _fetchAllAddedCoinsFromDatabase() {
    return _cacheManager.getValues();
  }

  List<MyCoin> fetchAllCoinsFromService() {
    List<MyCoin> aa = [];
    aa.addAll(fetchTryCoinsFromService());
    aa.addAll(fetchUsdtCoinsFromService());
    aa.addAll(fetchBtcCoinsFromService());
    aa.addAll(fetchEthCoinsFromService());
    aa.addAll(fetchGechoCoinsFromService());
    return aa;
  }

  List<MyCoin> fetchTryCoinsFromService() {
    try {
      return _serviceViewModel.getTryCoinList;
    } catch (e) {
      print(e);
      throw ("FETCH ALL COINS ERRORR");
    }
  }

  List<MyCoin> fetchUsdtCoinsFromService() {
    try {
      return _serviceViewModel.getUsdtCoinList;
    } catch (e) {
      print(e);
      throw ("FETCH ALL COINS ERRORR");
    }
  }

  List<MyCoin> fetchBtcCoinsFromService() {
    try {
      return _serviceViewModel.getBtcCoinList;
    } catch (e) {
      print(e);
      throw ("FETCH ALL COINS ERRORR");
    }
  }

  List<MyCoin> fetchEthCoinsFromService() {
    try {
      return _serviceViewModel.getEthCoinList;
    } catch (e) {
      print(e);
      throw ("FETCH ALL COINS ERRORR");
    }
  }

  List<MyCoin> fetchGechoCoinsFromService() {
    try {
      return _serviceViewModel.getGechoUsdtCoinList;
    } catch (e) {
      print(e);
      throw ("FETCH ALL COINS ERRORR");
    }
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
