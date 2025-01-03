import 'package:flutter/material.dart';
import 'package:flutter_blog/_core/utils/my_http.dart';
import 'package:flutter_blog/data/repository/user_repository.dart';
import 'package:flutter_blog/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

// 로그인을 하면 username, token 등등을 집어넣고 isLogin은 true로 변경
class SessionUser {
  int? id;
  String? username;
  String? accessToken;
  bool? isLogin;

  SessionUser({this.id, this.username, this.accessToken, this.isLogin});
}

// 뷰 모델이 필요 없는 페이지에서 글로벌하게 사용하는 ViewModel (로그인, 회원가입, 내정보수정 등에 사용)
class SessionGVM extends Notifier<SessionUser> {
  // TODO 2: 모름
  final mContext = navigatorKey.currentContext!;

  UserRepository userRepository = const UserRepository();

  @override
  SessionUser build() {
    return SessionUser(
        id: null, username: null, accessToken: null, isLogin: false);
  }

  Future<void> login(String username, String password) async {
    final body = {
      "username": username,
      "password": password,
    };

    // final 대신 var도 사용 가능
    final (responseBody, accessToken) =
        await userRepository.findByUsernameAndPassword(body);

    if (!responseBody["success"]) {
      ScaffoldMessenger.of(mContext!).showSnackBar(
        SnackBar(content: Text("로그인 실패 : ${responseBody["errorMessage"]}")),
      );
      return;
    }

    // 1. SessionUser 갱신
    Map<String, dynamic> data = responseBody["response"];
    state = SessionUser(
        id: data["id"],
        username: data["username"],
        accessToken: accessToken,
        isLogin: true);

    // 2. 토큰을 Storage 저장. 오래걸리기 때문에 await 필수
    await secureStorage.write(key: "accessToken", value: accessToken); // I/O

    // 3. Dio 토큰 세팅
    dio.options.headers = {"Autohrization": accessToken};

    Logger().d(dio.options.headers);

    Navigator.popAndPushNamed(mContext, "/post/list");
  }

  Future<void> join(String username, String email, String password) async {
    final body = {
      "username": username,
      "email": email,
      "password": password,
    };

    Map<String, dynamic> responseBody = await userRepository.save(body);

    if (!responseBody["success"]) {
      ScaffoldMessenger.of(mContext!).showSnackBar(
        SnackBar(content: Text("회원가입 실패 : ${responseBody["errorMessage"]}")),
      );
      return;
    }

    Navigator.pushNamed(mContext, "/login");
  }

  Future<void> logout() async {}

  Future<void> autoLogin() async {
    Future.delayed(
      Duration(seconds: 3),
      () {
        Navigator.popAndPushNamed(mContext, "/login");
      },
    );
  }
}

final sessionProvider = NotifierProvider<SessionGVM, SessionUser>(() {
  return SessionGVM();
});
