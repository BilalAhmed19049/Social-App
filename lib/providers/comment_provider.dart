import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

import '../models/comment_model.dart';

class CommentProvider with ChangeNotifier {
  List<CommentModel> _comments = [];

  List<CommentModel> get comments => _comments;
  StreamSubscription<List<CommentModel>>? _commentsSubscription;

  void startCommentsStream(String postId) {
    //print('comment stream si working');

    _commentsSubscription = FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => CommentModel.fromMap(doc.data()))
            .toList())
        .listen((comments) {
      _comments = comments;
      notifyListeners();
    });
  }

  Future<bool> saveComment(String postId, CommentModel comment) async {
    var ref = FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .doc();
    comment.id = ref.id;

    await ref.set(comment.toMap());
    return true;
    print('Comment saved: $comment');
  }

  @override
  void dispose() {
    _commentsSubscription?.cancel();
    super.dispose();
  }
}
