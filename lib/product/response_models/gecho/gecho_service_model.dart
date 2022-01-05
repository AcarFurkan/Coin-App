import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

import '../../../core/model/base_model/base_model.dart';

part 'gecho_service_model.g.dart';

List<Gecho> gechoFromJson(String str) =>
    List<Gecho>.from(json.decode(str).map((x) => Gecho.fromJson(x)));

String gechoToJson(List<Gecho> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

@JsonSerializable(fieldRename: FieldRename.snake)
class Gecho extends BaseModel {
  Gecho({
    this.id,
    this.symbol,
    this.name,
    this.image,
    this.currentPrice,
    this.high24H,
    this.low24H,
    this.priceChange24H,
    this.priceChangePercentage24H,
    this.ath,
    this.athChangePercentage,
    this.athDate,
    this.atl,
    this.atlChangePercentage,
    this.atlDate,
    this.lastUpdated,
  });

  String? id;
  String? symbol;
  String? name;
  String? image;
  double? currentPrice;
  @JsonKey(name: "high_24h")
  double? high24H;
  @JsonKey(name: "low_24h")
  double? low24H;
  @JsonKey(name: "price_change_24h")
  double? priceChange24H;
  @JsonKey(name: "price_change_percentage_24h")
  double? priceChangePercentage24H;

  double? ath;

  double? athChangePercentage;
  DateTime? athDate;
  double? atl;
  double? atlChangePercentage;
  DateTime? atlDate;
  DateTime? lastUpdated;

  factory Gecho.fromJson(Map<String, dynamic> json) => _$GechoFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$GechoToJson(this);

  @override
  fromJson(Map<String, dynamic> json) {
    return _$GechoFromJson(json);
  }
}
