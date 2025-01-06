import 'package:dio/dio.dart';

import '../../_core/utils/my_http.dart';

class PostRepository {
  const PostRepository();

  // 게시글 목록
  Future<Map<String, dynamic>> findAll({int page = 0}) async {
    Response response =
        await dio.get("/api/post", queryParameters: {"page": page});
    Map<String, dynamic> body = response.data;

    return body;
  }

  // 게시글 찾기 (디테일 페이지)
  Future<Map<String, dynamic>> findById(int id) async {
    Response response = await dio.get("/api/post/$id");
    Map<String, dynamic> body = response.data;

    return body;
  }

  // 게시글 삭제
  Future<Map<String, dynamic>> deleteById(int? id) async {
    Response response = await dio.delete("/api/post/$id");
    Map<String, dynamic> body = response.data;

    return body;
  }
}
