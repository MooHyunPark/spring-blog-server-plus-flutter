import 'package:flutter/material.dart';
import 'package:flutter_blog/data/repository/post_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../../data/model/Post.dart';
import '../../../../main.dart';

class PostListModel {
  bool isFirst;
  bool isLast;
  int pageNumber;
  int size;
  int totalPage;
  List<Post> posts;

  PostListModel(
      {required this.isFirst,
      required this.isLast,
      required this.pageNumber,
      required this.size,
      required this.totalPage,
      required this.posts});

  PostListModel.fromMap(Map<String, dynamic> map)
      : isFirst = map["isFirst"],
        isLast = map["isLast"],
        pageNumber = map["pageNumber"],
        size = map["size"],
        totalPage = map["totalPage"],
        posts = (map["posts"] as List<dynamic>)
            .map((e) => Post.fromMap(e))
            .toList();

  PostListModel copyWith(
      {bool? isFirst,
      bool? isLast,
      int? pageNumber,
      int? size,
      int? totalPage,
      List<Post>? posts}) {
    return PostListModel(
        isFirst: isFirst ?? this.isFirst,
        isLast: isLast ?? this.isLast,
        pageNumber: pageNumber ?? this.pageNumber,
        size: size ?? this.size,
        totalPage: totalPage ?? this.totalPage,
        posts: posts ?? this.posts);
  }
}

final postListProvider =
    NotifierProvider.autoDispose<PostListVM, PostListModel?>(() {
  return PostListVM();
});

class PostListVM extends AutoDisposeNotifier<PostListModel?> {
  // 슬라이드를 통해 새로고침 할 때 필요함
  final refreshCtrl = RefreshController();

  final mContext = navigatorKey.currentContext!;
  PostRepository postRepository = const PostRepository();

  @override
  PostListModel? build() {
    // 가비지 컬렉션이 바로 정리하지 않을 수 있기 때문에 직접 닫아준다.
    ref.onDispose(
      () {
        refreshCtrl.dispose();
      },
    );

    init();
    return null;
  }

  // 1. 페이지 초기화
  Future<void> init() async {
    Map<String, dynamic> responseBody = await postRepository.findAll();

    if (!responseBody["success"]) {
      ScaffoldMessenger.of(mContext!).showSnackBar(
        SnackBar(
            content: Text("게시글 목록 보기 실패 : ${responseBody["errorMessage"]}")),
      );
      return;
    }
    state = PostListModel.fromMap(responseBody["response"]);
    // init 메서드가 종료되면, ui 도는것을 멈추게 함
    refreshCtrl.refreshCompleted();
  }

  void remove(int? id) {
    PostListModel model = state!;
    model.posts = model.posts.where((p) => p.id != id).toList();
    state = state!.copyWith(posts: model.posts);
  }

  void add(Post post) {
    PostListModel model = state!;
    model.posts = [post, ...model.posts];
    state = state!.copyWith(posts: model.posts);
  }

  void search(int? id) {
    PostListModel model = state!;
    model.posts = model.posts.where((p) => p.id == id).toList();
    state = state!.copyWith(posts: model.posts);
  }

  // 2. 페이징 로드
  Future<void> nextList() async {
    PostListModel postListModel = state!;

    // 마지막 페이지라면 추가 로드를 하지 않음
    if (postListModel.isLast) {
      await Future.delayed(Duration(milliseconds: 500));
      refreshCtrl.loadComplete();
      return;
    }

    Map<String, dynamic> responseBody =
        await postRepository.findAll(page: state!.pageNumber + 1);

    if (!responseBody["success"]) {
      ScaffoldMessenger.of(mContext!).showSnackBar(
        SnackBar(content: Text("게시글 로드 실패 : ${responseBody["errorMessage"]}")),
      );
      return;
    }

    PostListModel prevModel = state!;
    PostListModel nextModel = PostListModel.fromMap(responseBody["response"]);
    state = nextModel.copyWith(posts: [...prevModel.posts, ...nextModel.posts]);
    refreshCtrl.loadComplete();
  }

  void update(int postId, String title, String content) {
    PostListModel model = state!;
    List<Post> postList = model.posts.map(
      (e) {
        if (e.id == postId) {
          e.title = title;
          e.content = content;
        }
        return e;
      },
    ).toList();
    state = model.copyWith(posts: postList);
  }
}
