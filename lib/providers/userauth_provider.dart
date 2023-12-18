import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

import '../models/user_data_model.dart';
import '../utils/constants.dart';
import 'data_provider.dart';

class UserAuth extends ChangeNotifier {
  late String imageUrl;
  File? pickedImage;
  final FirebaseAuth _auth = Constants.auth;
  final CollectionReference _userCollection = Constants.users;
  StreamSubscription<UserDataModel>?
      _userDataSubscription; //Stream Subscription variable
  UserDataModel? _userData; //UserDataModel private variable to use in class
  UserDataModel? get userData =>
      _userData; //UserDataModel getter to use globally
  // final dataProvider = Provider.of<DataProvider>(context, listen: false);
  DataProvider dataProvider = DataProvider();

  UserAuth() {
    fetchUserData(); // calling fetch user data function in constructor to get all data from stream as anu object of UserAuth calls
    notifyListeners(); //notifying all UserAuth Consumers
  }

  Future<void> fetchUserData() async {
    // in this function stream which is getting users
    try {
      _userDataSubscription = userDataStream.listen((userData) {
        //User Data stream fetching current user data and populating it in local list_userData
        _userData = userData;
        notifyListeners();
      });
    } catch (error) {
      print('Error fetching user data: $error');
    }
  }

  Future<bool> logIn({
    required BuildContext context,
    required UserDataModel userData,
  }) async {
    try {
      final UserCredential result = await _auth.signInWithEmailAndPassword(
          email: userData.email, password: userData.password);
      dataProvider.init();
      await fetchUserData();
      notifyListeners();
      return true;
    } catch (error) {
      print('Login error is $error');
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Following error $error')));
      return false;
    }
  }

  Future<bool> signUp({
    required UserDataModel userData,
    required BuildContext context,
  }) async {
    try {
      final UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: userData.email, password: userData.password);
      userData.id = result.user!.uid; //saving new user id in UserDataModel
      pickedImage = null; // making the File image null as new user signup
      await _userCollection
          .doc(result.user!.uid)
          .set(userData.toMap()); // setting user data in firestore
      await fetchUserData(); //fetch user data
      return true;
    } catch (error) {
      print('The error is$error');
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Following error in signup$error')));
      return false;
    }
  }

  Future<bool> logOut() async {
    try {
      await _auth.signOut();
      _userDataSubscription?.cancel();
      _userDataSubscription = null;
      _userData = null;

      //  dataProvider.dispose();
      return true;
    } catch (error) {
      print('Logout error is $error');
      return false;
    }
  }

  Future<bool> updateData(
      Map<String, dynamic> data, String uid, BuildContext context) async {
    try {
      await _userCollection.doc(uid).update(data);

      return true;
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Following error in data update$error')));
      return false;
    }
  }

  Stream<UserDataModel> get userDataStream {
    return _userCollection
        .doc(_auth.currentUser!.uid)
        .snapshots()
        .map((snapshot) {
      return UserDataModel.fromMap(snapshot.data() as Map<String, dynamic>);
    });
  }

  Future<void> pickImage() async {
    ImagePicker imagePicker = ImagePicker();
    XFile? file = await imagePicker.pickImage(source: ImageSource.gallery);
    pickedImage = File(file!.path);
    notifyListeners();
  }

  Future<String> uploadImage(File imageFile) async {
    String fileName = path.basename(imageFile.path);
    Reference firebaseStorageRef =
        FirebaseStorage.instance.ref().child('uploads/$fileName');
    UploadTask uploadTask = firebaseStorageRef.putFile(imageFile);
    await uploadTask.whenComplete(() => null);
    String imageUrl = await firebaseStorageRef.getDownloadURL();
    return imageUrl;
  }

  @override
  void dispose() {
    _userDataSubscription?.cancel();
    super.dispose();
  }
}
