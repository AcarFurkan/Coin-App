// To parse this JSON data, do
//
//     final hurriyet = hurriyetFromJson(jsonString);

import 'package:json_annotation/json_annotation.dart';

part 'hurriyet_response_model.g.dart';

@JsonSerializable(createToJson: false)
class Hurriyet {
  Hurriyet({
    this.sembol,
    this.tarih,
    this.alis,
    this.satis,
    this.acilis,
    this.yuksek,
    this.dusuk,
    this.kapanis,
    this.hacimlot,
    this.aort,
    this.hacimtldun,
    this.dunkukapanis,
    this.oncekikapanis,
    this.tavan,
    this.taban,
    this.yilyuksek,
    this.yildusuk,
    this.ayyuksek,
    this.aydusuk,
    this.haftayuksek,
    this.haftadusuk,
    this.oncekiyilkapanis,
    this.oncekiaykapanis,
    this.oncekihaftakapanis,
    this.yilortalama,
    this.ayortalama,
    this.haftaortalama,
    this.yuzdedegisim,
    this.sermaye,
    this.saklamaor,
    this.netkar,
    this.net,
    this.fiyatkaz,
    this.ozsermaye,
    this.xU100Ag,
    this.aciklama,
  });

  String? sembol;
  DateTime? tarih;
  double? alis;
  double? satis;
  double? acilis;
  double? yuksek;

  double? dusuk;

  double? kapanis;

  double? hacimlot;

  double? aort;

  double? hacimtldun;

  double? dunkukapanis;
  double? oncekikapanis;
  double? tavan;
  double? taban;
  double? yilyuksek;
  double? yildusuk;
  double? ayyuksek;
  double? aydusuk;
  double? haftayuksek;
  double? haftadusuk;
  double? oncekiyilkapanis;
  double? oncekiaykapanis;
  double? oncekihaftakapanis;
  double? yilortalama;
  double? ayortalama;
  double? haftaortalama;

  double? yuzdedegisim;

  double? sermaye;
  double? saklamaor;
  double? netkar;
  double? net;
  double? fiyatkaz;

  double? ozsermaye;
  double? xU100Ag;
  String? aciklama;

  factory Hurriyet.fromJson(Map<String, dynamic> json) =>
      _$HurriyetFromJson(json);
}
