import 'package:collection/collection.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:social_app/providers/data_provider.dart';
import 'package:social_app/utils/helper_functions.dart';

import '../models/post_model.dart';
import '../models/user_data_model.dart';
import '../utils/constants.dart';

class UserDetailsPage extends StatelessWidget {
  final String? userId;

  UserDetailsPage({required this.userId});

  @override
  Widget build(BuildContext context) {
    return Consumer<DataProvider>(builder: (context, dataProvider, child) {
      dataProvider.fetchUserData(
          userId!); //fetch the data of that user on which user tap in search screen
      return Scaffold(
        appBar: AppBar(
          title: Text("${dataProvider.userData?.fullname?.trim()}'s Profile"),
        ),
        body: dataProvider.userData == null
            ? CircularProgressIndicator()
            : Center(
                child: Column(
                  children: <Widget>[
                    ClipOval(
                      child: Image.network(
                        dataProvider.userData?.url ?? Constants.logoImage,
                        height: 110,
                        width: 110,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Text(
                      dataProvider.userData!.fullname ?? 'Username',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      dataProvider.userData!.email!,
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    Gap(50),
                    if (!dataProvider.userData!.friends.contains(userId))
                      ElevatedButton(
                        onPressed: () {
                          bool requestSent = dataProvider.sendFriendRequest(
                              FirebaseAuth.instance.currentUser!.uid, userId!);
                          if (requestSent) {
                            HelperFunctions.showSnackBar(
                                context, 'Request sent successfully');
                          }
                        },
                        child: Text('Send Friend Request'),
                      ),
                    if (dataProvider.userData!.friends.contains(userId))
                      Text('Friends'),
                    Expanded(
                        child: ListView.builder(
                            itemCount: dataProvider.posts.length,
                            itemBuilder: (context, index) {
                              PostModel post = dataProvider.posts[index];

                              UserDataModel? postOwner =
                                  dataProvider.usersList.firstWhereOrNull(
                                (user) => user.id == post.uid,
                              );
                            }))
                  ],
                ),
              ),
      );
    });
  }
}
