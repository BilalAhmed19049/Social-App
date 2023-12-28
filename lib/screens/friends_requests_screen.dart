import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_app/models/user_data_model.dart';

import '../providers/data_provider.dart';

class FriendsRequestsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<DataProvider>(
      builder: (context, dataProvider, child) {
        UserDataModel currentUser = dataProvider.usersList.firstWhere(
            (user) => user.id == FirebaseAuth.instance.currentUser!.uid);

        return Scaffold(
          appBar: AppBar(
            title: const Text("Friends & Requests"),
          ),
          body: Column(
            children: <Widget>[
              // Friends section
              const Text(
                "Friends",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: currentUser.friends.length,
                  itemBuilder: (context, index) {
                    UserDataModel friend = dataProvider.usersList.firstWhere(
                        (user) => user.id == currentUser.friends[index]);
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage:
                            NetworkImage(friend.url ?? 'No user image'),
                      ),
                      title: Text('${friend.fullname}'),
                    );
                  },
                ),
              ),

              // Requests section
              const Text(
                "Requests",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: currentUser.requests.length,
                  itemBuilder: (context, index) {
                    print('Folowing are the requests ${currentUser.requests}');
                    UserDataModel requester = dataProvider.usersList.firstWhere(
                        (user) => user.id == currentUser.requests[index]);

                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage:
                            NetworkImage(requester.url ?? 'No user image'),
                      ),
                      title: Text('${requester.fullname}'),
                      trailing: ElevatedButton(
                        onPressed: () {
                          dataProvider.acceptFriendRequest(requester.id!,
                              FirebaseAuth.instance.currentUser!.uid);
                        },
                        child: const Text('Accept Friend Request'),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
