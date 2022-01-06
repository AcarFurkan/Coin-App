import 'package:json_annotation/json_annotation.dart';

part 'my_user_model.g.dart';

@JsonSerializable()
class MyUser {
  String? email;
  String? name;
  bool? isBackUpActive;
  String? backUpType;
  @JsonKey(ignore: true)
  DateTime? updatedAt;
  int? level;

  MyUser(
      {this.email,
      this.name,
      this.isBackUpActive = false,
      this.backUpType = "never",
      this.updatedAt,
      this.level});

  Map<String, dynamic> toMap() => _$MyUserToJson(this);

  factory MyUser.fromJson(Map<String, dynamic> json) => _$MyUserFromJson(json);
  //NEDEN BU ŞEKİLDE OLUYOR BAK
  /*  MyUser.fromMap(Map<String, dynamic> map)
      : userID = map['userID'],
        email = map['email'],
        userName = map['userName'],
        profilURL = map['profilURL'],
        createdAt = (map['createdAt'] as Timestamp).toDate(),
        updatedAt = (map['updatedAt'] as Timestamp).toDate(),
        seviye = map['seviye'];*/
}
