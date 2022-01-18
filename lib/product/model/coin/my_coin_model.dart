import 'package:coin_with_architecture/features/settings/subpage/audio_settings/model/audio_model.dart';
import 'package:hive/hive.dart';

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
  Map<String, dynamic> toMap() {
    return {
      'isAlarmActive': isAlarmActive,
      'currencyName': name,
      'isFavorite': isFavorite,
      'id': id,
      'lastPrice': lastPrice
    };
  }

  factory MainCurrencyModel.fromJson(Map<String, dynamic> json) =>
      MainCurrencyModel(
        id: json["id"] == null ? null : json["id"],
        name: json["currencyName"] == null ? null : json["currencyName"],
        isAlarmActive:
            json["isAlarmActive"] == null ? null : json["isAlarmActive"],
        isFavorite: json["isFavorite"] == null ? null : json["isFavorite"],
        lastPrice: json["lastPrice"] == null ? null : json["lastPrice"],
      );

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

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MainCurrencyModel && other.id == id;
  }

  @override
  int get hashCode {
    return id.hashCode;
  }
}
