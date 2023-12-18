import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:social_app/models/user_data_model.dart';
import 'package:social_app/providers/data_provider.dart';
import 'package:social_app/utils/constants.dart';
import 'package:social_app/widgets/message_card.dart';
import 'package:social_app/widgets/text_widget.dart';

import '../models/message_model.dart';
import '../utils/colors.dart';

class ChatScreen extends StatefulWidget {
  @override
  ChatScreen({super.key, required this.user});

  final UserDataModel user;

  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  DataProvider dataProvider = DataProvider();

  List<MessageModel> _list = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: CColors.t1,
      appBar: AppBar(
        backgroundColor: CColors.backgroundColor,
        automaticallyImplyLeading: false,
        flexibleSpace: _appBar(),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                  stream: dataProvider.getUsersStream(),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                      case ConnectionState.none:
                        return const Center(
                          child: CircularProgressIndicator(),
                        );

                      case ConnectionState.active:
                      //case ConnetionState.done:

                      case ConnectionState.done:
                        final _list = [];
                        _list.clear();
                        _list.add(MessageModel(
                            toId: '1212',
                            msg: 'hello!',
                            read: '',
                            type: '',
                            fromId: Constants.currentID,
                            sent: '11:00 AM'));
                        _list.add(MessageModel(
                            toId: Constants.currentID,
                            msg: 'Hi! How are you',
                            read: '',
                            type: '',
                            fromId: 'abcd',
                            sent: '1:00 PM'));

                        if (_list.isNotEmpty) {
                          return ListView.builder(
                              itemCount: _list.length,
                              padding: EdgeInsets.only(top: 10),
                              physics: const BouncingScrollPhysics(),
                              itemBuilder: (context, index) {
                                return MessageCard(message: _list[index]);
                              });
                        } else {
                          return const Center(
                            child: Text('Say Hi!👋',
                                style: TextStyle(fontSize: 16)),
                          );
                        }
                    }
                  }),
            ),
            _chatInput(),
            // Text(widget.user.fullname!),
            // Text(),
          ],
        ),
      ),
    );
  }

  Widget _appBar() {
    return Padding(
      padding: EdgeInsets.only(top: 25),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back),
          ),
          ClipOval(
            child: Image.network(
              widget.user.url!,
              width: 50,
            ),
          ),
          Gap(10),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextWidget(
                  color: CColors.grey8,
                  size: 18,
                  text: widget.user.fullname!,
                  fontWeight: FontWeight.bold),
              TextWidget(
                  color: CColors.grey8,
                  size: 14,
                  text: 'Last seen not available',
                  fontWeight: FontWeight.normal),
            ],
          ),
        ],
      ),
    );
  }

  Widget _chatInput() {
    return Row(
      children: [
        Expanded(
          child: Card(
            child: Row(
              children: [
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.emoji_emotions,
                    color: CColors.t3,
                  ),
                ),
                Expanded(
                  child: TextField(
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: InputDecoration(
                      hintText: 'Type message.....',
                      hintStyle: TextStyle(color: CColors.t2),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.image,
                    color: CColors.t3,
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.camera_alt_rounded,
                    color: CColors.t3,
                  ),
                )
              ],
            ),
          ),
        ),
        IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.send,
              color: CColors.red7,
            ))
      ],
    );
  }
}
