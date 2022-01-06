// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MyUser _$MyUserFromJson(Map<String, dynamic> json) => MyUser(
      email: json['email'] as String?,
      name: json['name'] as String?,
      isBackUpActive: json['isBackUpActive'] as bool? ?? false,
      backUpType: json['backUpType'] as String? ?? "never",
      level: json['level'] as int?,
    );

Map<String, dynamic> _$MyUserToJson(MyUser instance) => <String, dynamic>{
      'email': instance.email,
      'name': instance.name,
      'isBackUpActive': instance.isBackUpActive,
      'backUpType': instance.backUpType,
      'level': instance.level,
    };
