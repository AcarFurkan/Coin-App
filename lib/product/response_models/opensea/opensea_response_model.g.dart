// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'opensea_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OpenSea _$OpenSeaFromJson(Map<String, dynamic> json) => OpenSea(
      oneDayVolume: (json['one_day_volume'] as num?)?.toDouble(),
      oneDayChange: (json['one_day_change'] as num?)?.toDouble(),
      oneDaySales: (json['one_day_sales'] as num?)?.toDouble(),
      oneDayAveragePrice: (json['one_day_average_price'] as num?)?.toDouble(),
      sevenDayVolume: (json['seven_day_volume'] as num?)?.toDouble(),
      sevenDayChange: (json['seven_day_change'] as num?)?.toDouble(),
      sevenDaySales: (json['seven_day_sales'] as num?)?.toDouble(),
      sevenDayAveragePrice:
          (json['seven_day_average_price'] as num?)?.toDouble(),
      thirtyDayVolume: (json['thirty_day_volume'] as num?)?.toDouble(),
      thirtyDayChange: (json['thirty_day_change'] as num?)?.toDouble(),
      thirtyDaySales: (json['thirty_day_sales'] as num?)?.toDouble(),
      thirtyDayAveragePrice:
          (json['thirty_day_average_price'] as num?)?.toDouble(),
      totalVolume: (json['total_volume'] as num?)?.toDouble(),
      totalSales: (json['total_sales'] as num?)?.toDouble(),
      totalSupply: (json['total_supply'] as num?)?.toDouble(),
      count: (json['count'] as num?)?.toDouble(),
      numOwners: (json['num_owners'] as num?)?.toDouble(),
      averagePrice: (json['average_price'] as num?)?.toDouble(),
      numReports: (json['num_reports'] as num?)?.toDouble(),
      marketCap: (json['market_cap'] as num?)?.toDouble(),
      floorPrice: (json['floor_price'] as num?)?.toDouble(),
    );
