// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hurriyet_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Hurriyet _$HurriyetFromJson(Map<String, dynamic> json) => Hurriyet(
      sembol: json['sembol'] as String?,
      tarih: json['tarih'] == null
          ? null
          : DateTime.parse(json['tarih'] as String),
      alis: (json['alis'] as num?)?.toDouble(),
      satis: (json['satis'] as num?)?.toDouble(),
      acilis: (json['acilis'] as num?)?.toDouble(),
      yuksek: (json['yuksek'] as num?)?.toDouble(),
      dusuk: (json['dusuk'] as num?)?.toDouble(),
      kapanis: (json['kapanis'] as num?)?.toDouble(),
      hacimlot: (json['hacimlot'] as num?)?.toDouble(),
      aort: (json['aort'] as num?)?.toDouble(),
      hacimtldun: (json['hacimtldun'] as num?)?.toDouble(),
      dunkukapanis: (json['dunkukapanis'] as num?)?.toDouble(),
      oncekikapanis: (json['oncekikapanis'] as num?)?.toDouble(),
      tavan: (json['tavan'] as num?)?.toDouble(),
      taban: (json['taban'] as num?)?.toDouble(),
      yilyuksek: (json['yilyuksek'] as num?)?.toDouble(),
      yildusuk: (json['yildusuk'] as num?)?.toDouble(),
      ayyuksek: (json['ayyuksek'] as num?)?.toDouble(),
      aydusuk: (json['aydusuk'] as num?)?.toDouble(),
      haftayuksek: (json['haftayuksek'] as num?)?.toDouble(),
      haftadusuk: (json['haftadusuk'] as num?)?.toDouble(),
      oncekiyilkapanis: (json['oncekiyilkapanis'] as num?)?.toDouble(),
      oncekiaykapanis: (json['oncekiaykapanis'] as num?)?.toDouble(),
      oncekihaftakapanis: (json['oncekihaftakapanis'] as num?)?.toDouble(),
      yilortalama: (json['yilortalama'] as num?)?.toDouble(),
      ayortalama: (json['ayortalama'] as num?)?.toDouble(),
      haftaortalama: (json['haftaortalama'] as num?)?.toDouble(),
      yuzdedegisim: (json['yuzdedegisim'] as num?)?.toDouble(),
      sermaye: (json['sermaye'] as num?)?.toDouble(),
      saklamaor: (json['saklamaor'] as num?)?.toDouble(),
      netkar: (json['netkar'] as num?)?.toDouble(),
      net: (json['net'] as num?)?.toDouble(),
      fiyatkaz: (json['fiyatkaz'] as num?)?.toDouble(),
      ozsermaye: (json['ozsermaye'] as num?)?.toDouble(),
      xU100Ag: (json['xU100Ag'] as num?)?.toDouble(),
      aciklama: json['aciklama'] as String?,
    );
