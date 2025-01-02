import 'package:flutter/material.dart';
import 'package:flutter_blog/data/repository/user_repository.dart';
import 'package:flutter_blog/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

  Future<void> login() async {}

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
      print('여기 오냐?1');
      print('여기 오냐?1');
      print('여기 오냐?1');
      print('여기 오냐?1');
      print('여기 오냐?1');
      return;
    }

    print('여기 오냐?2');
    print('여기 오냐?2');
    print('여기 오냐?2');
    print('여기 오냐?2');
    print('여기 오냐?2');

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
