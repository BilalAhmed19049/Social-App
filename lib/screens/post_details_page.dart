import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_app/providers/comment_provider.dart';
import 'package:social_app/utils/helper_functions.dart';
import 'package:social_app/widgets/text_button_widget.dart';
import 'package:social_app/widgets/text_widget.dart';
import 'package:social_app/widgets/textfield_widget.dart';

import '../models/comment_model.dart';
import '../models/post_model.dart';
import '../models/user_data_model.dart';
import '../providers/data_provider.dart';
import '../utils/colors.dart';

class PostDetailsPage extends StatelessWidget {
  final PostModel post;

  PostDetailsPage({required this.post});

  // In post_details_page.dart
  TextEditingController commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
//     final dataProvider = Provider.of<DataProvider>(context);
// print('POST ID IS HERE:${post.id}');
    // dataProvider.startCommentsStream(post.id!);
    return Consumer<CommentProvider>(
      builder: (context, commentProvider, child) {
        commentProvider.startCommentsStream(post.id!);
        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(10.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: 200,
                    width: double.infinity,
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
                    hintText: '',
                    isObscure: false,
                  ),
                  TextButtonWidget(
                      onPressed: () async {
                        bool commentDone = await commentProvider.saveComment(
                            post.id!,
                            CommentModel(
                              uid: FirebaseAuth.instance.currentUser!.uid,
                              text: commentController.text,
                              postId: post.id,
                            ));
                        if (commentDone) {
                          commentController.clear();
                          HelperFunctions.showSnackBar(
                              context, 'Comment is done');
                        }
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
    return Consumer<CommentProvider>(
        builder: (context, commentProvider, child) {
      return Consumer<DataProvider>(builder: (context, dataProvider, child) {
        return Column(
          children: commentProvider.comments.map((comment) {
            UserDataModel? commentOwner = dataProvider.usersList
                .firstWhere((user) => user.id == comment.uid);

            return ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(commentOwner.url!),
              ),
              title: Text(commentOwner.fullname!),
              subtitle: Text(comment.text!),
            );
          }).toList(),
        );
      });
    });
  }
}
