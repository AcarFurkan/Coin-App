// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gecho_id_list_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GechoAllIdListAdapter extends TypeAdapter<GechoAllIdList> {
  @override
  final int typeId = 2;

  @override
  GechoAllIdList read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GechoAllIdList();
  }

  @override
  void write(BinaryWriter writer, GechoAllIdList obj) {
    writer..writeByte(0);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GechoAllIdListAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GechoAllIdList _$GechoAllIdListFromJson(Map<String, dynamic> json) =>
    GechoAllIdList(
      id: json['id'] as String?,
      symbol: json['symbol'] as String?,
      name: json['name'] as String?,
    );

Map<String, dynamic> _$GechoAllIdListToJson(GechoAllIdList instance) =>
    <String, dynamic>{
      'id': instance.id,
      'symbol': instance.symbol,
      'name': instance.name,
    };
