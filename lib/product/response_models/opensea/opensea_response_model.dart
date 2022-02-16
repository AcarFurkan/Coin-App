import 'package:json_annotation/json_annotation.dart';
part 'opensea_response_model.g.dart';

@JsonSerializable(createToJson: false, fieldRename: FieldRename.snake)
class OpenSea {
  double? oneDayVolume;
  double? oneDayChange;
  double? oneDaySales;
  double? oneDayAveragePrice;
  double? sevenDayVolume;
  double? sevenDayChange;
  double? sevenDaySales;
  double? sevenDayAveragePrice;
  double? thirtyDayVolume;
  double? thirtyDayChange;
  double? thirtyDaySales;
  double? thirtyDayAveragePrice;
  double? totalVolume;
  double? totalSales;
  double? totalSupply;
  double? count;
  double? numOwners;
  double? averagePrice;
  double? numReports;
  double? marketCap;
  double? floorPrice;

  OpenSea(
      {this.oneDayVolume,
      this.oneDayChange,
      this.oneDaySales,
      this.oneDayAveragePrice,
      this.sevenDayVolume,
      this.sevenDayChange,
      this.sevenDaySales,
      this.sevenDayAveragePrice,
      this.thirtyDayVolume,
      this.thirtyDayChange,
      this.thirtyDaySales,
      this.thirtyDayAveragePrice,
      this.totalVolume,
      this.totalSales,
      this.totalSupply,
      this.count,
      this.numOwners,
      this.averagePrice,
      this.numReports,
      this.marketCap,
      this.floorPrice});

  factory OpenSea.fromJson(Map<String, dynamic> json) =>
      _$OpenSeaFromJson(json);
}
