import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_app/models/chat_model.dart';
import 'package:social_app/models/message_model.dart';
import 'package:social_app/models/user_data_model.dart';

import '../providers/chat_provider.dart';
import '../screens/chat_screen.dart';
import '../utils/colors.dart';
import '../utils/my_date_util.dart';

class ChatUserCard extends StatelessWidget {
  ChatUserCard(
      {super.key,
      required this.UserPhoto,
      required this.userName,
      required this.lastSeen,
      required this.lastMessage,
      required this.user,
      required this.chatUserModel});

  final String UserPhoto, userName, lastSeen, lastMessage;
  final UserDataModel user;
  MessageModel? _message;

  //
  //
  final ChatUserModel chatUserModel;

  @override
  Widget build(BuildContext context) {
    return Card(
        margin: EdgeInsets.all(7),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (ctx) => ChatScreen(
                          user: user,
                        )));
          },
          child: StreamBuilder(
            stream: ChatProvider.getLastMessage(user),
            builder: (context, snapshot) {
              final data = snapshot.data?.docs;

              final list =
                  data?.map((e) => MessageModel.fromMap(e.data())).toList() ??
                      [];
              if (list.isNotEmpty) {
                _message = list[0];
              }
              return ListTile(
                //user profile pic
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(UserPhoto),
                ),

                //user name
                title: Text(userName),

                //last message
                subtitle: Text(
                  _message?.msg ?? user.about ?? 'Default Value',
                  maxLines: 1,
                ),

                //last message time
                trailing: _message == null
                    ? null
                    : _message!.read.isEmpty &&
                            _message!.fromId !=
                                FirebaseAuth.instance.currentUser!.uid
                        ? Container(
                            width: 15,
                            height: 15,
                            decoration: BoxDecoration(
                                color: CColors.green,
                                borderRadius: BorderRadius.circular(10)),
                          )
                        :
//Text('hello'),
                        Text(DateUtil.getLastMessageTime(
                            context: context, time: _message!.sent)),
              );
            },
          ),
        ));
  }
}
