import 'package:flutter/material.dart';
import 'package:social_app/widgets/text_widget.dart';

import '../models/message_model.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';

class MessageCard extends StatelessWidget {
  MessageCard({super.key, required this.message});

  final MessageModel message;

  @override
  Widget build(BuildContext context) {
    return Constants.currentID == message.fromId
        ? _tealMessage() // user own message
        : _greyMessage(); // other user/ friend message
  }

  Widget _greyMessage() {
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
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                      topRight: Radius.circular(30))),
              child: TextWidget(
                color: CColors.black,
                size: 15,
                text: message.msg,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
          //Gap(5),
          TextWidget(
              color: Colors.black38,
              size: 13,
              text: message.sent,
              fontWeight: FontWeight.normal),
        ],
      ),
    );
  }

  Widget _tealMessage() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                Icons.done_all_outlined,
                color: Colors.blue,
              ),
              TextWidget(
                  color: Colors.black38,
                  size: 13,
                  text: message.sent,
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
              child: TextWidget(
                color: CColors.black,
                size: 15,
                text: message.msg,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
