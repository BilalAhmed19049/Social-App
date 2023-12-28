import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'dart:developer';

//import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:social_app/models/message_model.dart';
import 'package:social_app/models/user_data_model.dart';

import '../utils/constants.dart';

class ChatProvider extends ChangeNotifier {
  static late UserDataModel me;
  static FirebaseMessaging fMessaging = FirebaseMessaging.instance;

  late StreamSubscription<QuerySnapshot<Map<String, dynamic>>>
      _messageSubscription;
  List<MessageModel> _messages = [];

  List<MessageModel> get messages => _messages;
  UserDataModel? user;
  static var currentId = FirebaseAuth.instance.currentUser!.uid;

// it will generate conversation ID
  static String getConversationID(String id) =>
      currentId.hashCode <= id.hashCode
          ? '${currentId}_$id'
          : '${id}_${currentId}';

  Future<void> fetchMessages(UserDataModel user) async {
    _messageSubscription = FirebaseFirestore.instance
        .collection('chat/${getConversationID(user.id!)}/messages/')
        .orderBy('sent', descending: false)
        .snapshots()
        .listen((snapshot) {
      _messages =
          snapshot.docs.map((doc) => MessageModel.fromMap(doc.data())).toList();
      print('Fetched ${_messages.length} messages');
      notifyListeners();
    });
  }

  //it will send message to specific user
  static Future<void> sendMessage(
      UserDataModel user, String msg, Type type) async {
    //messaging sending time + ID
    final time = DateTime.now().millisecondsSinceEpoch.toString();

    final MessageModel message = MessageModel(
        toId: user.id,
        msg: msg,
        read: '',
        fromId: currentId,
        sent: time,
        type: type);
    final ref = FirebaseFirestore.instance
        .collection('chat/${getConversationID(user.id!)}/messages/');
    await ref.doc(time).set(message.toMap()).then((value) =>
        sendPushNotification(user, type == Type.text ? msg : 'image'));
    print("Getting messages for path: ${getConversationID(user.id!)}");
  }

  static Future<void> updateMessageReadStatus(MessageModel message) async {
    FirebaseFirestore.instance
        .collection('chat/${getConversationID(message.fromId)}/messages/')
        .doc(message.sent)
        .update({'read': DateTime.now().millisecondsSinceEpoch.toString()});
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getLastMessage(
      UserDataModel user) {
    return FirebaseFirestore.instance
        .collection('chat/${getConversationID(user.id!)}/messages/')
        .orderBy('sent', descending: true)
        .limit(1)
        .snapshots();
  }

  static Future<void> sendChatImage(UserDataModel user, File file) async {
    final ext = file.path.split('.').last;

    //storage file ref with path
    final ref = FirebaseStorage.instance.ref().child(
        'chatImages/${getConversationID(user.id!)}/${DateTime.now().millisecondsSinceEpoch}.$ext');

    //uploading image
    await ref
        .putFile(file, SettableMetadata(contentType: 'image/$ext'))
        .then((p0) {
      print('Data Transferred: ${p0.bytesTransferred / 1000} kb');
    });

    //updating image in firestore database
    final imageUrl = await ref.getDownloadURL();
    await sendMessage(user, imageUrl, Type.image);
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getUserInfo(
      UserDataModel user) {
    return Constants.users.where('id', isEqualTo: user.id).snapshots();
  }

  static Future<void> getFirebaseMessagingToken() async {
    //await fMessaging.requestPermission();
    await fMessaging.getToken().then((t) {
      if (t != null) {
        me.pushToken = t;
        log('Push TOKEN $t');
      }
    });
  }

  static Future<void> updateActiveStatus(bool isOnline) async {
    Constants.users.doc(currentId).update({
      'isOnline': isOnline,
      'lastActive': DateTime.now().millisecondsSinceEpoch.toString(),
      'pushToken': me.pushToken,
    });
  }

  static Future<void> getSelfInfo() async {
    await Constants.users.doc(currentId).get().then((user) async {
      if (user.exists) {
        me = UserDataModel.fromMap(user.data()!);
        await getFirebaseMessagingToken();

        //for setting user status to active
        ChatProvider.updateActiveStatus(true);
        log('My Data: ${user.data()}');
      }
    });
  }

  static Future<void> sendPushNotification(
      UserDataModel user, String msg) async {
    try {
      final body = {
        "to": user.pushToken,
        "notification": {
          "title": me.fullname, //our name should be send
          "body": msg,
          "android_channel_id": "chats"
        },
      };

      var res = await post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
          headers: {
            HttpHeaders.contentTypeHeader: 'application/json',
            HttpHeaders.authorizationHeader:
                'key=AAAAXdJJi34:APA91bH5I5F4jWMs4A3Wr6wxQYU1TvHLeQLGtcsoFJG-6LBfIv6BbLJuSFiUMbdqz0F8ERDEU3KNlU7TUHtuFbq2HcwxdLcAwUhoFITaSnOiSmdXay5z26GWvhISQfaL96fxfGq87DB1'
          },
          body: jsonEncode(body));
      log('Response status: ${res.statusCode}');
      log('Response body: ${res.body}');
    } catch (e) {
      log('\nsendPushNotificationE: $e');
    }
  }

  @override
  void dispose() {
    _messageSubscription.cancel();
    super.dispose();
  }
}
