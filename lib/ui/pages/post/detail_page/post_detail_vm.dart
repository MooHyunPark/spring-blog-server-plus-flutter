import 'package:flutter/material.dart';
import 'package:flutter_blog/data/repository/post_repository.dart';
import 'package:flutter_blog/ui/pages/post/list_page/post_list_vm.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../data/model/Post.dart';
import '../../../../main.dart';

class PostDetailModel {
  Post post;

  PostDetailModel.fromMap(Map<String, dynamic> map) : post = Post.fromMap(map);
}

// autoDispose를 적게되면 화면 파괴시 vm도 같이 삭제시켜준다.
final postDetailProvider = NotifierProvider.family
    .autoDispose<PostDetailVM, PostDetailModel?, int>(() {
  return PostDetailVM();
});

class PostDetailVM extends AutoDisposeFamilyNotifier<PostDetailModel?, int> {
  PostRepository postRepository = const PostRepository();
  final mContext = navigatorKey.currentContext!;

  @override
  PostDetailModel? build(id) {
    init(id);
    return null;
  }

  Future<void> init(int id) async {
    Map<String, dynamic> responseBody = await postRepository.findById(id);

    if (!responseBody["success"]) {
      ScaffoldMessenger.of(mContext!).showSnackBar(
        SnackBar(
            content: Text("게시글 상세 보기 실패 : ${responseBody["errorMessage"]}")),
      );
      return;
    }
    PostDetailModel model = PostDetailModel.fromMap(responseBody["response"]);
    state = model;
  }

  Future<void> deleteById(int? id) async {
    Map<String, dynamic> responseBody = await postRepository.deleteById(id);

    if (!responseBody["success"]) {
      ScaffoldMessenger.of(mContext!).showSnackBar(
        SnackBar(content: Text("게시글 삭제 실패 : ${responseBody["errorMessage"]}")),
      );
      return;
    }

    // PostlistVM의 상태를 변경
    ref.read(postListProvider.notifier).remove(id);

    // 화면 파괴시 autoDispose 됨
    Navigator.pop(mContext);
  }
}
