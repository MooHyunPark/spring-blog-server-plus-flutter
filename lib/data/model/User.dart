class User {
  int? id;
  String? username;
  String? imgUrl;

  User.fromMap(Map<String, dynamic> map)
      : this.id = map["id"] ?? null,
        this.username = map["username"] ?? null,
        this.imgUrl = map["imgUrl"] ?? null;
}
