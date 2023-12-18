// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
//
// import '../models/comment_model.dart';
// import '../models/user_data_model.dart';
//
// class CommentWidget extends StatelessWidget {
//   final Comments comment;
//   UserDataModel? user;
//
//   CommentWidget({required this.comment, required UserDataModel user});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: Row(
//         children: [
//           CircleAvatar(backgroundImage: NetworkImage(user!.url!)),
//           SizedBox(width: 8),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(user!.fullname!),
//               Text(comment.text!),
//             ],
//           )
//         ],
//       ),
//     );
//   }
//
// }
