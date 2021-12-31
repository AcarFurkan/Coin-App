// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bitexen_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Bitexen _$BitexenFromJson(Map<String, dynamic> json) => Bitexen(
      market: json['market'] == null
          ? null
          : Market.fromJson(json['market'] as Map<String, dynamic>),
      bid: json['bid'] as String?,
      ask: json['ask'] as String?,
      lastPrice: json['last_price'] as String?,
      lastSize: json['last_size'] as String?,
      volume24H: json['volume_24h'] as String?,
      change24H: json['change_24h'] as String?,
      low24H: json['low_24h'] as String?,
      high24H: json['high_24h'] as String?,
      avg24H: json['avg_24h'] as String?,
      timestamp: json['timestamp'] as String?,
    );

Map<String, dynamic> _$BitexenToJson(Bitexen instance) => <String, dynamic>{
      'market': instance.market,
      'bid': instance.bid,
      'ask': instance.ask,
      'last_price': instance.lastPrice,
      'last_size': instance.lastSize,
      'volume_24h': instance.volume24H,
      'change_24h': instance.change24H,
      'low_24h': instance.low24H,
      'high_24h': instance.high24H,
      'avg_24h': instance.avg24H,
      'timestamp': instance.timestamp,
    };

Market _$MarketFromJson(Map<String, dynamic> json) => Market(
      marketCode: json['market_code'] as String?,
      baseCurrencyCode: json['base_currency_code'] as String?,
      counterCurrencyCode: json['counter_currency_code'] as String?,
    );

Map<String, dynamic> _$MarketToJson(Market instance) => <String, dynamic>{
      'market_code': instance.marketCode,
      'base_currency_code': instance.baseCurrencyCode,
      'counter_currency_code': instance.counterCurrencyCode,
    };
