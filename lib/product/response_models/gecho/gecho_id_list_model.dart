import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
part 'gecho_id_list_model.g.dart';

@JsonSerializable()
@HiveType(typeId: 2)
class GechoAllIdList {
  String? id;
  String? symbol;
  String? name;
  @JsonKey(ignore: true)
  HiveList? ids;

  GechoAllIdList({this.id, this.symbol, this.name});

  factory GechoAllIdList.fromJson(Map<String, dynamic> json) =>
      _$GechoAllIdListFromJson(json);

  Map<String, dynamic> toJson() => _$GechoAllIdListToJson(this);
}
