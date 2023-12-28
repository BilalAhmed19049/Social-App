import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_app/providers/chat_provider.dart';
import 'package:social_app/widgets/text_widget.dart';

import '../models/message_model.dart';
import '../utils/colors.dart';
import '../utils/my_date_util.dart';

class MessageCard extends StatelessWidget {
  MessageCard({super.key, required this.message});

  final MessageModel message;

  @override
  Widget build(BuildContext context) {
    return FirebaseAuth.instance.currentUser!.uid == message.fromId
        ? _tealMessage(context) // user own message
        : _greyMessage(context); // other user/ friend message
  }

  Widget _greyMessage(BuildContext context) {
    if (message.read.isEmpty) {
      ChatProvider.updateMessageReadStatus(message);
      //print('Message read status updated');
    }
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Container(
              padding: EdgeInsets.all(10),
              // margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              decoration: BoxDecoration(
                  color: CColors.grey3,
                  border: Border.all(color: CColors.grey5),
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                      topRight: Radius.circular(30))),
              child: message.type == Type.text
                  ? TextWidget(
                      color: CColors.black,
                      size: 15,
                      text: message.msg!,
                      fontWeight: FontWeight.normal,
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.network(
                        message.msg!,
                      ),
                    ),
            ),
          ),
          //Gap(5),
          TextWidget(
              color: Colors.black38,
              size: 13,
              text: DateUtil.getFormattedTime(
                  context: context, time: message.sent),
              fontWeight: FontWeight.normal),
        ],
      ),
    );
  }

  Widget _tealMessage(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              if (message.read.isNotEmpty)
                Icon(
                  Icons.done_all_outlined,
                  color: Colors.blue,
                ),
              TextWidget(
                  color: Colors.black38,
                  size: 13,
                  text: DateUtil.getFormattedTime(
                      context: context, time: message.sent),
                  fontWeight: FontWeight.normal),
            ],
          ),
          Flexible(
            child: Container(
              padding: EdgeInsets.all(10),
              // margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              decoration: BoxDecoration(
                  color: CColors.t1,
                  border: Border.all(color: CColors.t4),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      bottomLeft: Radius.circular(30),
                      topRight: Radius.circular(30))),
              child: message.type == Type.text
                  ? TextWidget(
                      color: CColors.black,
                      size: 15,
                      text: message.msg!,
                      fontWeight: FontWeight.normal,
                    )
                  :
                  // Container(
                  //   child: Image.network(
                  //         message.msg!,
                  //       ),
                  // ),

                  ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.network(
                        message.msg!,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}