import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:social_app/models/user_data_model.dart';
import 'package:social_app/providers/chat_provider.dart';
import 'package:social_app/widgets/message_card.dart';
import 'package:social_app/widgets/text_widget.dart';

import '../models/message_model.dart';
import '../utils/colors.dart';
import '../utils/my_date_util.dart';

class ChatScreen extends StatefulWidget {
  @override
  @override
  ChatScreen({
    super.key,
    required this.user,
  });

  final UserDataModel user;

  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  void initState() {
    super.initState();
    Provider.of<ChatProvider>(context, listen: false)
        .fetchMessages(widget.user);
  }

  // DataProvider dataProvider = DataProvider();
  TextEditingController messageController = TextEditingController();
  bool _isUploading = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatProvider>(
      builder: (context, chatProvider, child) {
        print(
            'Accessed ${chatProvider.messages.length} messages'); // Print statement
        return Scaffold(
          appBar: AppBar(
            backgroundColor: CColors.backgroundColor,
            automaticallyImplyLeading: false,
            flexibleSpace: _appBar(widget.user),
          ),
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    //reverse: true,
                    itemCount: chatProvider.messages.length,
                    padding: EdgeInsets.only(top: 10),
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      // print(
                      //     'Displaying message ${index + 1}'); // Print statement
                      return MessageCard(message: chatProvider.messages[index]);
                    },
                  ),
                ),
                if (_isUploading)
                  const Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                          padding:
                              EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                          child: CircularProgressIndicator(strokeWidth: 2))),
                _chatInput(widget.user),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _appBar(UserDataModel user) {
    return Padding(
        padding: EdgeInsets.only(top: 25),
        child: StreamBuilder(
            stream: ChatProvider.getUserInfo(user),
            builder: (context, snapshot) {
              final data = snapshot.data?.docs;
              final list =
                  data?.map((e) => UserDataModel.fromMap(e.data())).toList() ??
                      [];
              return Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.arrow_back),
                  ),
                  ClipOval(
                    child: Image.network(
                      list.isNotEmpty ? list[0].url! : widget.user.url!,
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
                          text: list.isNotEmpty
                              ? list[0].fullname!
                              : widget.user.fullname!,
                          fontWeight: FontWeight.bold),
                      Text(
                          list.isNotEmpty
                              ? list[0].isOnline
                                  ? 'Online'
                                  : DateUtil.getLastActiveTime(
                                      context: context,
                                      lastActive: list[0].lastActive!)
                              : DateUtil.getLastActiveTime(
                                  context: context,
                                  lastActive: widget.user.lastActive!),
                          style: const TextStyle(
                              fontSize: 13, color: Colors.black54)),
                    ],
                  ),
                ],
              );
            }));
  }

  Widget _chatInput(UserDataModel user) {
    return Row(
      children: [
        Expanded(
          child: Card(
            child: Row(
              children: [
                Gap(5),
                Expanded(
                  child: TextField(
                    controller: messageController,
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
                  onPressed: () async {
                    final ImagePicker picker = ImagePicker();
                    final List<XFile> images =
                        await picker.pickMultiImage(imageQuality: 70);
                    for (var i in images) {
                      setState(() => _isUploading = true);
                      await ChatProvider.sendChatImage(
                          widget.user, File(i.path));
                      setState(() => _isUploading = false);
                    }
                  },
                  icon: Icon(
                    Icons.image,
                    color: CColors.t3,
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    final ImagePicker picker = ImagePicker();
                    final XFile? image = await picker.pickImage(
                        source: ImageSource.camera, imageQuality: 30);
                    if (image != null) {
                      setState(() => _isUploading = true);

                      await ChatProvider.sendChatImage(
                          widget.user, File(image.path));
                      setState(() => _isUploading = false);
                    }
                  },
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
            onPressed: () {
              if (messageController.text.isNotEmpty) {
                ChatProvider.sendMessage(
                    widget.user, messageController.text, Type.text);
                messageController.clear();
              }
            },
            icon: Icon(
              Icons.send,
              color: CColors.t5,
            ))
      ],
    );
  }
}
