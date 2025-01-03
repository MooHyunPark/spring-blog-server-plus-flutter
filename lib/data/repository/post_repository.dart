import 'package:dio/dio.dart';

import '../../_core/utils/my_http.dart';

class PostRepository {
  const PostRepository();

  Future<Map<String, dynamic>> findAll({int page = 0}) async {
    Response response = await dio.get("/api/post/");
    Map<String, dynamic> body = response.data;

    return body;
  }
}
