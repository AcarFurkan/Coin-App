// To parse this JSON data, do
//
//     final coinCap = coinCapFromJson(jsonString);

import 'dart:convert';

CoinCap coinCapFromJson(String str) => CoinCap.fromJson(json.decode(str));

String coinCapToJson(CoinCap data) => json.encode(data.toJson());

class CoinCap {
  CoinCap({
    this.data,
    this.timestamp,
  });

  List<Datum>? data;
  int? timestamp;

  factory CoinCap.fromJson(Map<String, dynamic> json) => CoinCap(
        data: json["data"] == null
            ? null
            : List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        timestamp: json["timestamp"] == null ? null : json["timestamp"],
      );

  Map<String, dynamic> toJson() => {
        "data": data == null
            ? null
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        "timestamp": timestamp == null ? null : timestamp,
      };
}

class Datum {
  Datum({
    this.exchangeId,
    this.rank,
    this.baseSymbol,
    this.baseId,
    this.quoteSymbol,
    this.quoteId,
    this.priceQuote,
    this.priceUsd,
    this.volumeUsd24Hr,
    this.percentExchangeVolume,
    this.tradesCount24Hr,
    this.updated,
  });

  String? exchangeId;
  String? rank;
  String? baseSymbol;
  String? baseId;
  String? quoteSymbol;
  String? quoteId;
  String? priceQuote;
  String? priceUsd;
  String? volumeUsd24Hr;
  String? percentExchangeVolume;
  String? tradesCount24Hr;
  int? updated;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        exchangeId: json["exchangeId"] == null ? null : json["exchangeId"],
        rank: json["rank"] == null ? null : json["rank"],
        baseSymbol: json["baseSymbol"] == null ? null : json["baseSymbol"],
        baseId: json["baseId"] == null ? null : json["baseId"],
        quoteSymbol: json["quoteSymbol"] == null ? null : json["quoteSymbol"],
        quoteId: json["quoteId"] == null ? null : json["quoteId"],
        priceQuote: json["priceQuote"] == null ? null : json["priceQuote"],
        priceUsd: json["priceUsd"] == null ? null : json["priceUsd"],
        volumeUsd24Hr:
            json["volumeUsd24Hr"] == null ? null : json["volumeUsd24Hr"],
        percentExchangeVolume: json["percentExchangeVolume"] == null
            ? null
            : json["percentExchangeVolume"],
        tradesCount24Hr:
            json["tradesCount24Hr"] == null ? null : json["tradesCount24Hr"],
        updated: json["updated"] == null ? null : json["updated"],
      );

  Map<String, dynamic> toJson() => {
        "exchangeId": exchangeId == null ? null : exchangeId,
        "rank": rank == null ? null : rank,
        "baseSymbol": baseSymbol == null ? null : baseSymbol,
        "baseId": baseId == null ? null : baseId,
        "quoteSymbol": quoteSymbol == null ? null : quoteSymbol,
        "quoteId": quoteId == null ? null : quoteId,
        "priceQuote": priceQuote == null ? null : priceQuote,
        "priceUsd": priceUsd == null ? null : priceUsd,
        "volumeUsd24Hr": volumeUsd24Hr == null ? null : volumeUsd24Hr,
        "percentExchangeVolume":
            percentExchangeVolume == null ? null : percentExchangeVolume,
        "tradesCount24Hr": tradesCount24Hr == null ? null : tradesCount24Hr,
        "updated": updated == null ? null : updated,
      };
}
