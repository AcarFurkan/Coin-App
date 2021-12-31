import 'package:json_annotation/json_annotation.dart';
part 'truncgil_response_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, createToJson: false)
class Truncgil {
  Truncgil({this.buy, this.sell, this.change, this.updateDate});

  @JsonKey(ignore: true)
  String? id;
  @JsonKey(ignore: true)
  String? name;
  @JsonKey(name: "Alış")
  String? buy;
  @JsonKey(name: "Satış")
  String? sell;
  @JsonKey(name: "Değişim")
  String? change;
  @JsonKey(ignore: true)
  String? updateDate;

  factory Truncgil.fromJson(Map<String, dynamic> json) =>
      _$TruncgilFromJson(json);
}
