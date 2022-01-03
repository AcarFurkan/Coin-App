import 'package:hive/hive.dart';

import '../../features/settings/subpage/audio_settings/model/audio_model.dart';

part 'my_coin_model.g.dart';

// para birimi ve alarm
@HiveType(typeId: 1)
class MainCurrencyModel {
  @HiveField(0)
  String name;
  @HiveField(1)
  String? lastPrice;
  @HiveField(2)
  late bool isFavorite;
  @HiveField(3)
  double min;
  @HiveField(4)
  double max;
  @HiveField(5)
  late bool isAlarmActive;
  @HiveField(6)
  String? counterCurrencyCode;
  @HiveField(7)
  String id;
  @HiveField(8)
  late bool isMinAlarmActive;
  @HiveField(9)
  late bool isMaxAlarmActive;
  @HiveField(10)
  late String? priceControl;
  @HiveField(11)
  late String? changeOf24H;
  @HiveField(12)
  late String? percentageControl;
  @HiveField(13)
  late String? lowOf24h;
  @HiveField(14)
  late String? highOf24h;
  @HiveField(15)
  AudioModel? minAlarmAudio;
  @HiveField(16)
  AudioModel? maxAlarmAudio;
  @HiveField(17)
  bool? isMinLoop;
  @HiveField(18)
  bool? isMaxLoop;
  @HiveField(19)
  String? lastUpdate;

  MainCurrencyModel({
    required this.name,
    required this.lastPrice,
    required this.id,
    this.isFavorite = false,
    this.isAlarmActive = false,
    this.isMaxAlarmActive = false,
    this.isMinAlarmActive = false,
    this.counterCurrencyCode,
    this.priceControl = "CONSTANT",
    this.percentageControl = "CONSTANT",
    this.isMinLoop = false,
    this.isMaxLoop = false,
    this.lastUpdate,
    this.minAlarmAudio,
    this.maxAlarmAudio,
    this.highOf24h,
    this.lowOf24h,
    this.changeOf24H,
    this.min = 0,
    this.max = 0,
  });
}
