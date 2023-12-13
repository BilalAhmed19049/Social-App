import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import '../models/chat_model.dart';
import '../utils/constants.dart';

class ChatProvider extends ChangeNotifier {
  List<ChatModel> chats = [];

  List<ChatModel> getAllChats() {
    FirebaseFirestore.instance
        .collection('chats')
        .orderBy('lastActive', descending: true)
        .snapshots(includeMetadataChanges: true)
        .listen((chats) {
      this.chats =
          chats.docs.map((doc) => ChatModel.fromMap(doc.data())).toList();
    });
    notifyListeners();
    return chats;
  }

  Future<Stream<List<ChatModel>>> getChats() async {
    return FirebaseFirestore.instance
        .collection('chats')
        .where('users', arrayContains: Constants.currentID)
        .snapshots()
        .map((snap) =>
            snap.docs.map((doc) => ChatModel.fromMap(doc.data())).toList());
  }
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
