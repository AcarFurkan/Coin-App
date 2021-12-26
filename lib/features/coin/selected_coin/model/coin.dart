import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
part 'coin.g.dart';

Coin coinFromJson(String str) => Coin.fromJson(json.decode(str));

String coinToJson(Coin data) => json.encode(data.toJson());

@JsonSerializable()
class Coin {
  Coin({
    this.status,
    this.data,
  });

  String? status;
  Data? data;

  factory Coin.fromJson(Map<String, dynamic> json) => _$CoinFromJson(json);

  Map<String, dynamic> toJson() => _$CoinToJson(this);
}

@JsonSerializable()
class Data {
  Data({
    this.ticker,
  });

  Ticker? ticker;

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);

  Map<String, dynamic> toJson() => _$DataToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class Ticker {
  Ticker({
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

  factory Ticker.fromJson(Map<String, dynamic> json) => _$TickerFromJson(json);

  Map<String, dynamic> toJson() => _$TickerToJson(this);
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
