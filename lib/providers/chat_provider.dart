import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/firebase.dart';
import 'package:flutter/cupertino.dart';
import 'package:social_app/models/message_model.dart';

import '../models/chat_model.dart';
import '../utils/constants.dart';

class ChatProvider extends ChangeNotifier {

// it will generate conversation ID
  static String getConversationID(String id) =>
      Constants.currentID.hashCode <= id.hashCode
          ? '${Constants.currentID}_$id'
          : '${id}_${Constants.currentID}';

//it will get messages from a specific conversation
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages(
      ChatUserModel user) {
    return FirebaseFirestore.instance.collection(
        'chat/${getConversationID(user.id)}/messages/').snapshots();
  }

  static Future<void> sendMessage(ChatUserModel user, String msg) async {
    //messaging sending time + ID
    final time = DateTime
        .now()
        .millisecondsSinceEpoch
        .toString();
    final MessageModel
    final ref = FirebaseFirestore.instance.collection(
        'chat/${getConversationID(user.id)}/messages/');
    await ref.doc().set(data)
  }


// List<ChatUserModel> chats = [];
//
// List<ChatUserModel> getAllChats() {
//   FirebaseFirestore.instance
//       .collection('chats')
//       .orderBy('lastActive', descending: true)
//       .snapshots(includeMetadataChanges: true)
//       .listen((chats) {
//     this.chats =
//         chats.docs.map((doc) => ChatUserModel.fromMap(doc.data())).toList();
//   });
//   notifyListeners();
//   return chats;
// }
//
// Future<Stream<List<ChatUserModel>>> getChats() async {
//   return FirebaseFirestore.instance
//       .collection('chats')
//       .where('users', arrayContains: Constants.currentID)
//       .snapshots()
//       .map((snap) =>
//           snap.docs.map((doc) => ChatUserModel.fromMap(doc.data())).toList());
// }
// Stream<List<Message>> messagesStream(chatId) {
//   return FirebaseFirestore.instance
//       .collection('chats/$chatId/messages')
//       .orderBy('timestamp')
//       .snapshots()
//       .map((snap) => snap.docs
//       .map((doc) => Message.fromMap(doc.data()))
//       .toList());
//
// }
}
