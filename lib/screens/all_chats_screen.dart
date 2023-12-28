import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_app/models/chat_model.dart';
import 'package:social_app/providers/data_provider.dart';
import 'package:social_app/widgets/chat_user_card.dart';
import 'package:social_app/widgets/text_widget.dart';

import '../models/user_data_model.dart';
import '../utils/colors.dart';

class AllChatScreen extends StatefulWidget {
  AllChatScreen({super.key});

  @override
  State<AllChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<AllChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<DataProvider>(builder: (context, dataProvider, child) {
      UserDataModel currentUser = dataProvider.usersList.firstWhere(
          (user) => user.id == FirebaseAuth.instance.currentUser!.uid);
      print(currentUser.fullname);
      print('List of friends:');
      for (var friendId in currentUser.friends) {
        UserDataModel friend =
            dataProvider.usersList.firstWhere((user) => user.id == friendId);
        print('Friend: ${friend.fullname}');
      }
      return Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                TextWidget(
                    color: CColors.black,
                    size: 22,
                    text: 'Chats',
                    fontWeight: FontWeight.bold),
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
                        lastMessage: '',
                        user: friend,
                        chatUserModel: ChatUserModel(
                            about: friend.fullname!,
                            createdAt: '',
                            isOnline: '',
                            id: '',
                            lastActive: '',
                            pushToken: '',
                            uid: friend.id!),
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
