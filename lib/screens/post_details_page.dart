import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_app/widgets/text_button_widget.dart';
import 'package:social_app/widgets/text_widget.dart';
import 'package:social_app/widgets/textfield_widget.dart';

import '../models/comment_model.dart';
import '../models/post_model.dart';
import '../providers/data_provider.dart';
import '../utils/colors.dart';

class PostDetailsPage extends StatelessWidget {
  final PostModel post;

  PostDetailsPage({required this.post});

  TextEditingController commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<DataProvider>(
      builder: (context, dataProvider, child) {
        dataProvider.Post = post;
        return Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Container(
                    height: 200,
                    width: 200,
                    child: Image.network(post.postImg!),
                  ),
                  TextWidget(
                      color: CColors.grey8,
                      size: 18,
                      text: 'Likes',
                      fontWeight: FontWeight.bold),
                  _buildLikes(context),
                  TextWidget(
                      color: CColors.grey8,
                      size: 18,
                      text: 'Comments',
                      fontWeight: FontWeight.bold),
                  _buildComments(context),
                  TextFieldWidget(
                      labelText: 'Comment here',
                      controller: commentController,
                      fillColor: CColors.grey3,
                      textColor: CColors.grey5,
                      hintText: ''),
                  TextButtonWidget(
                      onPressed: () {
                        dataProvider.saveComment(
                            post.id!,
                            CommentModel(
                                commentText: commentController.text,
                                uid:
                                    '${FirebaseAuth.instance.currentUser!.uid}'));
                      },
                      text: 'Post',
                      color: CColors.black,
                      fontSize: 16,
                      withIcon: true,
                      icon: Icon(Icons.add))
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLikes(BuildContext context) {
    return Column(
      children: post.likes.map((likeUserId) {
        // Find user using like user's id
        var user = context
            .read<DataProvider>()
            .usersList
            .firstWhere((user) => user.id == likeUserId);

        return ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(user.url!),
          ),
          title: Text(user.fullname!),
        );
      }).toList(),
    );
  }

  Widget _buildComments(BuildContext context) {
    return Consumer<DataProvider>(builder: (context, dataProvider, child) {
      if (dataProvider.comments != null && dataProvider.comments!.isNotEmpty) {
        return Expanded(
            child: ListView.builder(
                itemCount: dataProvider.comments!.length,
                itemBuilder: (context, index) {
                  var comment = dataProvider.comments![index];
                  var user = context
                      .read<DataProvider>()
                      .usersList
                      .firstWhere((user) => user.id == comment.uid);
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(user.url!),
                    ),
                    title: Text(user.fullname!),
                    subtitle: Text(comment.commentText!),
                  );
                }));
      } else {
        return Text('No Comments yet');
      }
    });
  }
}
