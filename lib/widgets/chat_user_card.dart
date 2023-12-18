import 'package:flutter/material.dart';
import 'package:social_app/models/user_data_model.dart';

import '../screens/chat_screen.dart';

class ChatUserCard extends StatelessWidget {
  ChatUserCard(
      {super.key,
      required this.UserPhoto,
      required this.userName,
      required this.lastSeen,
      required this.lastMessage,
      required this.user});

  final String UserPhoto, userName, lastSeen, lastMessage;
  final UserDataModel user;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(7),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (ctx) => ChatScreen(user: user)));
        },
        child: ListTile(
          //user profile pic
          leading: CircleAvatar(
            backgroundImage: NetworkImage(UserPhoto),
          ),

          //user name
          title: Text(userName),

          //last message
          subtitle: Text(
            lastMessage,
            maxLines: 1,
          ),
          //last message time
          trailing: Text(lastSeen),
        ),
      ),
    );
  }
}
