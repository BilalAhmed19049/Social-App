import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_app/providers/data_provider.dart';
import 'package:social_app/widgets/chat_user_card.dart';
import 'package:social_app/widgets/text_widget.dart';

import '../models/user_data_model.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';

class AllChatScreen extends StatefulWidget {
  AllChatScreen({super.key});

  @override
  State<AllChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<AllChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<DataProvider>(builder: (context, dataProvider, child) {
      UserDataModel currentUser = dataProvider.usersList
          .firstWhere((user) => user.id == Constants.currentID);

      return Scaffold(
        appBar: AppBar(
          title: TextWidget(
              color: CColors.grey8,
              size: 20,
              text: 'Chats',
              fontWeight: FontWeight.bold),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: currentUser.friends.length,
                    itemBuilder: (context, index) {
                      UserDataModel friend = dataProvider.usersList.firstWhere(
                          (user) => user.id == currentUser.friends[index]);

                      return ChatUserCard(
                        UserPhoto: friend.url!,
                        userName: friend.fullname!,
                        lastSeen: 'Yesterday',
                        lastMessage: 'What is the plan',
                        user: friend,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
