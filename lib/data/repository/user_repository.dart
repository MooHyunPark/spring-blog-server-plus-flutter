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

  Future<(Map<String, dynamic>, String)> findByUsernameAndPassword(
      Map<String, dynamic> data) async {
    Response response = await dio.post("/login", data: data);
    Map<String, dynamic> body = response.data;
    //Logger().d(body); // test 코드 작성 직접해보기

    String accessToken = "";
    try {
      // 로그인에 실패하면 토큰이 없어 null 예외가 발생하기 때문에 try 사용
      accessToken = response
          .headers["Authorization"]![0]; // 헤더에 있는 토큰 값을 가져옴 / 0번지에 토큰이 있다.
    } catch (e) {}

    //Logger().d(accessToken);
    return (body, accessToken);
  }

  Future<Map<String, dynamic>> autoLogin(String accessToken) async {
    Response response = await dio.post("/auto/login",
        options: Options(headers: {"Authorization": accessToken}));
    Map<String, dynamic> body = response.data;
    return body;
  }
}
