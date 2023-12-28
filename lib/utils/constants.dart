import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Constants {
  // auth
  static var auth = FirebaseAuth.instance;

  // firestore collections
  static var firestore = FirebaseFirestore.instance;
  static var users = FirebaseFirestore.instance.collection('users');
  static var posts = FirebaseFirestore.instance.collection('posts');

  //Firebase Auth
  // static var currentID = FirebaseAuth.instance.currentUser!.uid;

  //images
  static const logoImage = 'assets/images/img_1.png';

  //text
  static const createFundText =
      'This is for your long term spending goals, like vacation, or car repairs. Not monthly expenses, but expenses that you know are coming! Enter an amount for your goal, and when you need to be that goal, then SEBET will let you know how much you need to budget each month to reach it!';
  static const addExpenseText =
      'Select a category to add an expense to your budget. But if you have an expense that just does not fit any current category, just click on';
}
