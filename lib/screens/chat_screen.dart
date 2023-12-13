import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_app/models/chat_model.dart';
import 'package:social_app/providers/data_provider.dart';
import 'package:social_app/widgets/text_widget.dart';

import '../models/user_data_model.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';

class ChatScreen extends StatelessWidget {
  ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ChatModel? chatModel;
    return Consumer<DataProvider>(builder: (context, dataProvider, child) {
      UserDataModel currentUser = dataProvider.usersList
          .firstWhere((user) => user.id == Constants.currentID);

      return Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              TextWidget(
                  color: CColors.grey8,
                  size: 20,
                  text: 'Chats',
                  fontWeight: FontWeight.bold),
              Expanded(
                child: ListView.builder(
                  itemCount: currentUser.friends.length,
                  itemBuilder: (context, index) {
                    UserDataModel friend = dataProvider.usersList.firstWhere(
                        (user) => user.id == currentUser.friends[index]);
                    return ListTile(
                      leading:
                          Stack(alignment: Alignment.bottomRight, children: [
                        CircleAvatar(
                          backgroundImage:
                              NetworkImage(friend.url ?? 'No user image'),
                        ),
                        // CircleAvatar(
                        //   backgroundColor: chatModel!.isOnline
                        //   ?Colors.green
                        //   :Colors.grey,
                        //   radius: 5,
                        // )
                      ]),
                      title: Text(friend.fullname!),
                      // subtitle: Text(
                      //   'Last Active: ${timeago.format(chatModel.lastActive)}',
                      //   maxLines: 2,
                      // ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
