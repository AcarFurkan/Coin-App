class MyUser {
  String? email;
  String? name;
  MyUser({
    this.email,
    this.name,
  });

  Map<String, dynamic> toMap() {
    return {'email': email, 'userName': name};
  }

  factory MyUser.fromJson(Map<String, dynamic> json) => MyUser(
        email: json["email"] == null ? null : json["email"],
        name: json["name"] == null ? null : json["name"],
      );
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
