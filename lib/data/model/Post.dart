import 'package:intl/intl.dart';

import 'User.dart';

class Post {
  int? id;
  String? title;
  String? content;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? bookmarkCount;
  bool? isBookmark;
  User? user;

  Post.fromMap(Map<String, dynamic> map)
      : this.id = map["id"],
        this.title = map["title"],
        this.content = map["content"],
        this.createdAt = DateFormat("yyyy-mm-dd").parse(map["createdAt"]),
        this.updatedAt = DateFormat("yyyy-mm-dd").parse(map["updatedAt"]),
        this.bookmarkCount = map["bookmarkCount"],
        this.isBookmark = map["isBookmark"],
        this.user = User.fromMap(map["user"]);
}
