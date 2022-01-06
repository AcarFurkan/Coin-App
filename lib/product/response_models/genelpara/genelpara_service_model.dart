// To parse this JSON data, do
//
//     final genelPara = genelParaFromJson(jsonString);

import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'genelpara_service_model.g.dart';

GenelPara genelParaFromJson(String str) => GenelPara.fromJson(json.decode(str));

@JsonSerializable(createToJson: false)
class GenelPara {
  GenelPara({
    this.satis,
    this.alis,
    this.degisim,
  });

  String? satis;
  String? alis;
  String? degisim;
  @JsonKey(ignore: true)
  String? id;

  factory GenelPara.fromJson(Map<String, dynamic> json) =>
      _$GenelParaFromJson(json);
}
