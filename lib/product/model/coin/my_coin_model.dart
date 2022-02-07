import '../../../features/settings/subpage/audio_settings/model/audio_model.dart';
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'my_coin_model.g.dart';

// para birimi ve alarm
@JsonSerializable()
@HiveType(typeId: 1)
class MainCurrencyModel {
  @JsonKey(name: "currencyName")
  @HiveField(0)
  String name; //**** */
  @HiveField(1)
  String? lastPrice; //**** */
  @JsonKey(ignore: true)
  @HiveField(2)
  late bool isFavorite;
  @JsonKey(ignore: true)
  @HiveField(3)
  double min;
  @JsonKey(ignore: true)
  @HiveField(4)
  double max;
  @HiveField(5)
  late bool isAlarmActive; //**** */
  @HiveField(6)
  @JsonKey(ignore: true)
  String? counterCurrencyCode;
  @HiveField(7)
  String id; //**** */
  @JsonKey(ignore: true)
  @HiveField(8)
  late bool isMinAlarmActive;
  @JsonKey(ignore: true)
  @HiveField(9)
  late bool isMaxAlarmActive;
  @JsonKey(ignore: true)
  @HiveField(10)
  late String? priceControl;
  @JsonKey(ignore: true)
  @HiveField(11)
  late String? changeOf24H;
  @JsonKey(ignore: true)
  @HiveField(12)
  late String? percentageControl;
  @JsonKey(ignore: true)
  @HiveField(13)
  late String? lowOf24h;
  @JsonKey(ignore: true)
  @HiveField(14)
  late String? highOf24h;
  @JsonKey(ignore: true)
  @HiveField(15)
  AudioModel? minAlarmAudio;
  @JsonKey(ignore: true)
  @HiveField(16)
  AudioModel? maxAlarmAudio;
  @JsonKey(ignore: true)
  @HiveField(17)
  bool? isMinLoop;
  @JsonKey(ignore: true)
  @HiveField(18)
  bool? isMaxLoop;
  @JsonKey(ignore: true)
  @HiveField(19)
  String? lastUpdate; //**** */
  @HiveField(20)
  String? addedPrice;
  @JsonKey(ignore: true)
  @HiveField(21)
  String? changeOfPercentageSincesAddedTime;
  Map<String, dynamic> toMap() => _$MainCurrencyModelToJson(this);

  factory MainCurrencyModel.fromJson(Map<String, dynamic> json) =>
      _$MainCurrencyModelFromJson(json);

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
    this.addedPrice,
    this.changeOfPercentageSincesAddedTime,
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
