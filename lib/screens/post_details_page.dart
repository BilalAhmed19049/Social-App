import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_app/widgets/text_widget.dart';

import '../models/post_model.dart';
import '../providers/data_provider.dart';
import '../utils/colors.dart';

class PostDetailsPage extends StatelessWidget {
  final PostModel post;

  const PostDetailsPage({required this.post});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Show likes
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

            // Expanded(
            //   child: ListView.builder(
            //     itemCount: post.likes.length,
            //     itemBuilder: (context, index) {
            //       UserDataModel friend = dataProvider.usersList.firstWhere((user) => user.id == currentUser.friends[index]);
            //       return ListTile(
            //         leading: CircleAvatar(
            //           backgroundImage: NetworkImage(friend.url ?? 'No user image'),
            //         ),
            //         title: Text('${friend.fullname}'),
            //       );
            //     },
            //   ),
            // ),
            // Show comments
          ],
        ),
      ),
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
}
