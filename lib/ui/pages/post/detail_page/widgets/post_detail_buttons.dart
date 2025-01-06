import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blog/data/gvm/session_gvm.dart';
import 'package:flutter_blog/ui/pages/post/detail_page/post_detail_vm.dart';
import 'package:flutter_blog/ui/pages/post/update_page/post_update_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../data/model/Post.dart';

class PostDetailButtons extends ConsumerWidget {
  Post post;

  PostDetailButtons(this.post);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    SessionUser sessionUser = ref.read(sessionProvider);
    // family일 때 1번으로 창고가 만들어진 뒤, 다시 1번으로 창고를 만들면 싱글톤으로 관리 된다
    PostDetailVM vm = ref.read(postDetailProvider(post.id!).notifier);

    if (sessionUser.id == post.user!.id!) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          IconButton(
            onPressed: () {
              vm.deleteById(post.id);
            },
            icon: const Icon(CupertinoIcons.delete),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => PostUpdatePage(post)));
            },
            icon: const Icon(CupertinoIcons.pen),
          ),
        ],
      );
    } else {
      return SizedBox();
    }
  }
}
