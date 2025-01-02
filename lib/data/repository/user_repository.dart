import 'package:dio/dio.dart';

import '../../_core/utils/my_http.dart';

class UserRepository {
  const UserRepository();

  Future<Map<String, dynamic>> save(Map<String, dynamic> data) async {
    Response response = await dio.post("/join", data: data);
    Map<String, dynamic> body = response.data;
    //Logger().d(body); // test 코드 작성 직접해보기
    return body;
  }
}
