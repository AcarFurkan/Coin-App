// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gecho_service_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Gecho _$GechoFromJson(Map<String, dynamic> json) => Gecho(
      id: json['id'] as String?,
      symbol: json['symbol'] as String?,
      name: json['name'] as String?,
      image: json['image'] as String?,
      currentPrice: (json['current_price'] as num?)?.toDouble(),
      high24H: (json['high_24h'] as num?)?.toDouble(),
      low24H: (json['low_24h'] as num?)?.toDouble(),
      priceChange24H: (json['price_change_24h'] as num?)?.toDouble(),
      priceChangePercentage24H:
          (json['price_change_percentage_24h'] as num?)?.toDouble(),
      ath: (json['ath'] as num?)?.toDouble(),
      athChangePercentage: (json['ath_change_percentage'] as num?)?.toDouble(),
      athDate: json['ath_date'] == null
          ? null
          : DateTime.parse(json['ath_date'] as String),
      atl: (json['atl'] as num?)?.toDouble(),
      atlChangePercentage: (json['atl_change_percentage'] as num?)?.toDouble(),
      atlDate: json['atl_date'] == null
          ? null
          : DateTime.parse(json['atl_date'] as String),
      lastUpdated: json['last_updated'] == null
          ? null
          : DateTime.parse(json['last_updated'] as String),
    );

Map<String, dynamic> _$GechoToJson(Gecho instance) => <String, dynamic>{
      'id': instance.id,
      'symbol': instance.symbol,
      'name': instance.name,
      'image': instance.image,
      'current_price': instance.currentPrice,
      'high_24h': instance.high24H,
      'low_24h': instance.low24H,
      'price_change_24h': instance.priceChange24H,
      'price_change_percentage_24h': instance.priceChangePercentage24H,
      'ath': instance.ath,
      'ath_change_percentage': instance.athChangePercentage,
      'ath_date': instance.athDate?.toIso8601String(),
      'atl': instance.atl,
      'atl_change_percentage': instance.atlChangePercentage,
      'atl_date': instance.atlDate?.toIso8601String(),
      'last_updated': instance.lastUpdated?.toIso8601String(),
    };
