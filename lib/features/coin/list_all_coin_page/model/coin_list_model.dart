// To parse this JSON data, do
//
//     final coinList = coinListFromJson(jsonString);

import 'dart:convert';

CoinList coinListFromJson(String str) => CoinList.fromJson(json.decode(str));

String coinListToJson(CoinList data) => json.encode(data.toJson());

class CoinList {
  CoinList({
    this.status,
    this.data,
  });

  String? status;
  Data? data;

  factory CoinList.fromJson(Map<String, dynamic> json) => CoinList(
        status: json["status"] == null ? null : json["status"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status == null ? null : status,
        "data": data == null ? null : data!.toJson(),
      };
}

class Data {
  Data({this.ticker, this.tickerList});

  Map<String, Ticker>? ticker;
  List<Ticker>? tickerList;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        ticker: json["ticker"] == null
            ? null
            : Map.from(json["ticker"])
                .map((k, v) => MapEntry<String, Ticker>(k, Ticker.fromJson(v))),
      );

  Map<String, dynamic> toJson() => {
        "ticker": ticker == null
            ? null
            : Map.from(ticker!)
                .map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
      };
}

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
  String? volume24H;
  String? change24H;
  String? low24H;
  String? high24H;
  String? avg24H;
  String? timestamp;

  factory Ticker.fromJson(Map<String, dynamic> json) => Ticker(
        market: json["market"] == null ? null : Market.fromJson(json["market"]),
        bid: json["bid"] == null ? null : json["bid"],
        ask: json["ask"] == null ? null : json["ask"],
        lastPrice: json["last_price"] == null ? null : json["last_price"],
        lastSize: json["last_size"] == null ? null : json["last_size"],
        volume24H: json["volume_24h"] == null ? null : json["volume_24h"],
        change24H: json["change_24h"] == null ? null : json["change_24h"],
        low24H: json["low_24h"] == null ? null : json["low_24h"],
        high24H: json["high_24h"] == null ? null : json["high_24h"],
        avg24H: json["avg_24h"] == null ? null : json["avg_24h"],
        timestamp: json["timestamp"] == null ? null : json["timestamp"],
      );

  Map<String, dynamic> toJson() => {
        "market": market == null ? null : market!.toJson(),
        "bid": bid == null ? null : bid,
        "ask": ask == null ? null : ask,
        "last_price": lastPrice == null ? null : lastPrice,
        "last_size": lastSize == null ? null : lastSize,
        "volume_24h": volume24H == null ? null : volume24H,
        "change_24h": change24H == null ? null : change24H,
        "low_24h": low24H == null ? null : low24H,
        "high_24h": high24H == null ? null : high24H,
        "avg_24h": avg24H == null ? null : avg24H,
        "timestamp": timestamp == null ? null : timestamp,
      };
}

class Market {
  Market({
    this.marketCode,
    this.baseCurrencyCode,
    this.counterCurrencyCode,
  });

  String? marketCode;
  String? baseCurrencyCode;
  String? counterCurrencyCode;

  factory Market.fromJson(Map<String, dynamic> json) => Market(
        marketCode: json["market_code"] == null ? null : json["market_code"],
        baseCurrencyCode: json["base_currency_code"] == null
            ? null
            : json["base_currency_code"],
        counterCurrencyCode: json["counter_currency_code"] == null
            ? null
            : json["counter_currency_code"],
      );

  Map<String, dynamic> toJson() => {
        "market_code": marketCode == null ? null : marketCode,
        "base_currency_code":
            baseCurrencyCode == null ? null : baseCurrencyCode,
        "counter_currency_code":
            counterCurrencyCode == null ? null : counterCurrencyCode,
      };
}
