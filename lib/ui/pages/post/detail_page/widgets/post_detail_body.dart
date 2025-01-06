import 'package:flutter/material.dart';
import 'package:flutter_blog/_core/constants/size.dart';
import 'package:flutter_blog/ui/pages/post/detail_page/post_detail_vm.dart';
import 'package:flutter_blog/ui/pages/post/detail_page/widgets/post_detail_buttons.dart';
import 'package:flutter_blog/ui/pages/post/detail_page/widgets/post_detail_content.dart';
import 'package:flutter_blog/ui/pages/post/detail_page/widgets/post_detail_profile.dart';
import 'package:flutter_blog/ui/pages/post/detail_page/widgets/post_detail_title.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PostDetailBody extends ConsumerWidget {
  int postId;

  PostDetailBody(this.postId);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // FutureProvider(async와 await를 함수에 달 수 있다.),
    // StreamProvider(웹소켓처럼 스트림으로 데이터를 지속적으로 받는다),
    // StateProvider(전역데이터를 보관할 수 있다.),
    // NotifierProvider (현재 사용 중. 위 3가지를 모두 대체할 수 있다)
    PostDetailModel? model = ref.watch(postDetailProvider(postId));

    if (model == null) {
      return Center(child: CircularProgressIndicator());
    } else {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            PostDetailTitle("${model.post.title}"),
            const SizedBox(height: largeGap),
            PostDetailProfile(model.post),
            PostDetailButtons(model.post),
            const Divider(),
            const SizedBox(height: largeGap),
            PostDetailContent("${model.post.content}"),
          ],
        ),
      );
    }
  }
}
