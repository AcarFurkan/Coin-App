import 'dart:convert';
import 'package:coin_with_architecture/core/model/base_model/base_model.dart';
import 'package:json_annotation/json_annotation.dart';
part 'bitexen_response_model.g.dart';

Map<String, Bitexen> bitexenFromJson(dynamic str) => Map.from(str)
    .map((k, v) => MapEntry<String, Bitexen>(k, Bitexen.fromJson(v)));

String bitexenToJson(Map<String, dynamic> data) =>
    json.encode(Map.from(data).map((k, v) => MapEntry<String, dynamic>(k, v)));

@JsonSerializable(fieldRename: FieldRename.snake)
class Bitexen extends BaseModel {
  Bitexen({
    this.market,
    this.bid,
    this.ask,
    this.lastPrice,
    this.lastSize,
    this.volume24H,
    this.change24H,
    this.low24H,
    this.high24H,
    this.avg24H,
    this.timestamp,
  });

  Market? market;
  String? bid;
  String? ask;
  String? lastPrice;
  String? lastSize;
  @JsonKey(name: "volume_24h")
  String? volume24H;
  @JsonKey(name: "change_24h")
  String? change24H;
  @JsonKey(name: "low_24h")
  String? low24H;
  @JsonKey(name: "high_24h")
  String? high24H;
  @JsonKey(name: "avg_24h")
  String? avg24H;
  String? timestamp;

  factory Bitexen.fromJson(Map<String, dynamic> json) {
    return _$BitexenFromJson(json);
  }

  Map<String, dynamic> toJson() => _$BitexenToJson(this);

  @override
  fromJson(Map<String, dynamic> json) {
    return _$BitexenFromJson(json);
  }
}

@JsonSerializable(fieldRename: FieldRename.snake)
class Market {
  Market({
    this.marketCode,
    this.baseCurrencyCode,
    this.counterCurrencyCode,
  });

  String? marketCode;
  String? baseCurrencyCode;
  String? counterCurrencyCode;

  factory Market.fromJson(Map<String, dynamic> json) => _$MarketFromJson(json);

  Map<String, dynamic> toJson() => _$MarketToJson(this);
}
