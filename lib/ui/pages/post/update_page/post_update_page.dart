import 'package:flutter/material.dart';
import 'package:flutter_blog/ui/pages/post/update_page/widgets/post_update_body.dart';

import '../../../../data/model/Post.dart';

class PostUpdatePage extends StatelessWidget {
  Post post;

  PostUpdatePage(this.post);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: PostUpdateBody(post),
    );
  }
}
