import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

import '../models/post_model.dart';
import '../models/user_data_model.dart';
import '../utils/constants.dart';

class DataProvider with ChangeNotifier {
  UserDataModel? _userData;

  UserDataModel? get userData => _userData;

  StreamSubscription<List<UserDataModel>>? _usersSubscription;
  StreamSubscription<QuerySnapshot>? _postStreamSubscription;
  StreamSubscription<User?>? _authSubscription;

  // StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? stream;
  final CollectionReference _userCollection = Constants.users;
  final CollectionReference _postCollection = Constants.posts;

  List<UserDataModel> _usersList = [];

  List<UserDataModel> get usersList => _usersList;
  File? pickedImage;

  PostModel? post;

  DataProvider() {
    init();
  }

  void init() {
    _posts.clear();
    _authSubscription = FirebaseAuth.instance.authStateChanges().listen((user) {
      // check if the user logout/change then update the posts according to new user
      if (user != null) {
        // _posts.clear();
        startPostStream(user.uid);
        _usersSubscription = getUsersStream().listen((users) {
          _usersList = users;
          notifyListeners();
        });
      }
    });
  }

  List<PostModel> _posts = [];

  List<PostModel> get posts => _posts;

  void startPostStream(String userId) async {
    _posts.clear();
    getPostsFromUserAndFriends(userId).then((posts) {
      _posts = posts;
      //notifyListeners();
    });
  }

  void fetchUserData(String userId) {
    _userCollection.doc(userId).snapshots().listen((snapshot) {
      _userData =
          UserDataModel.fromMap(snapshot.data() as Map<String, dynamic>);
      notifyListeners();
    });
  }

  Stream<List<UserDataModel>> getUsersStream() {
    return Constants.users.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return UserDataModel.fromMap(doc.data());
      }).toList();
    });
  }

  bool sendFriendRequest(String senderId, String receiverId) {
    _userCollection.doc(receiverId).update({
      'requests': FieldValue.arrayUnion([senderId])
    });
    return true;
  }

  void acceptFriendRequest(String senderId, String receiverId) {
    _userCollection.doc(receiverId).update({
      'requests': FieldValue.arrayRemove([senderId]),
      'friends': FieldValue.arrayUnion([senderId])
    }).then((_) {
      _userCollection.doc(senderId).update({
        'friends': FieldValue.arrayUnion([receiverId])
      }).then((_) {
        notifyListeners();
      });
    });
  }

  Future<void> pickPost() async {
    ImagePicker imagePicker = ImagePicker();
    XFile? file = await imagePicker.pickImage(source: ImageSource.gallery);
    pickedImage = File(file!.path);
    notifyListeners();
  }

  Future<String> uploadPost(File imageFile) async {
    String fileName = path.basename(imageFile.path);
    Reference firebaseStorageRef =
        FirebaseStorage.instance.ref().child('posts/$fileName');
    UploadTask uploadTask = firebaseStorageRef.putFile(imageFile);
    await uploadTask.whenComplete(() => null);
    String imageUrl = await firebaseStorageRef.getDownloadURL();
    return imageUrl;
  }

  Future<bool> savePost(PostModel post) async {
    try {
      DocumentReference ref = await Constants.posts.add(post.toMap());
      post.id = ref.id;
      await ref.update({'id': ref.id});
      return true;
    } catch (error) {
      print('Error in saving post$error');
      return false;
    }
  }

  bool likePost(String postId, String likerId) {
    _postCollection.doc(postId).update({
      'likes': FieldValue.arrayUnion([likerId])
    });
    var post = _posts.firstWhere((element) =>
        element.id ==
        postId); //in list of posts where you find postId, update likes of that post id
    if (!post.likes.contains(likerId)) {
      post.likes.add(likerId);
    }
    notifyListeners();
    return true;
  }

  static printLikes(PostModel post) {
    print('Likes for post ${post.id}:');
    for (String userId in post.likes) {
      print(userId);
    }
  }

  Future<List<String>> getFriends(String userId) async {
    DocumentSnapshot snapshot = await _userCollection.doc(userId).get();
    List<String> friends = List<String>.from(snapshot['friends']);
    return friends;
  }

  Future<List<PostModel>> getPostsFromUserAndFriends(String userId) async {
    List<String> friends = await getFriends(userId);
    //friends.add(userId); // add the user himself
    List<PostModel> posts = [];

    // Cancel previous subscription, if any
    _postStreamSubscription?.cancel();

    // Subscribe to all posts
    _postStreamSubscription = Constants.posts
        .where('uid', whereIn: friends)
        .snapshots()
        .listen((querySnapshot) {
      // Clear existing posts
      posts.clear();

      // Add posts from the query result
      posts.addAll(querySnapshot.docs
          .map((doc) => PostModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList());

      // Notify listeners after each update
      notifyListeners();
    });
    return posts;
  }

  @override
  void dispose() {
    _usersSubscription?.cancel();
    _postStreamSubscription?.cancel();
    post?.likes = [];
    _userData?.friends = [];
    _userData?.requests = [];
    super.dispose();
  }
}
