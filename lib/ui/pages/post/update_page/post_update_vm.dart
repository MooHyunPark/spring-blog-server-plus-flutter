import 'package:flutter/material.dart';
import 'package:flutter_blog/data/repository/post_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../main.dart';
import '../detail_page/post_detail_vm.dart';
import '../list_page/post_list_vm.dart';

final postUpdateProvider = NotifierProvider<PostUpdateVM, int>(() {
  return PostUpdateVM();
});

class PostUpdateVM extends Notifier<int> {
  PostRepository postRepository = const PostRepository();
  final mContext = navigatorKey.currentContext!;

  @override
  int build() {
    return 0;
  }

  void postUpdate(int postId, String title, String content) async {
    final data = {"title": title, "content": content};
    Map<String, dynamic> responseBody =
        await postRepository.postUpdate(postId, data);

    if (!responseBody["success"]) {
      ScaffoldMessenger.of(mContext!).showSnackBar(
        SnackBar(content: Text("게시글 수정 실패 : ${responseBody["errorMessage"]}")),
      );
      return;
    }
    ref.read(postDetailProvider(postId).notifier).update(title, content);
    ref.read(postListProvider.notifier).update(postId, title, content);
    Navigator.pop(mContext);
  }
}
