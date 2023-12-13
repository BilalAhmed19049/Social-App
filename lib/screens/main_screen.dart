import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:social_app/providers/data_provider.dart';
import 'package:social_app/screens/post_details_page.dart';
import 'package:social_app/screens/post_upload_screen.dart';
import 'package:social_app/widgets/bottom_appbar_widget.dart';
import 'package:social_app/widgets/text_button_widget.dart';

import '../models/post_model.dart';
import '../models/user_data_model.dart';
import '../providers/userauth_provider.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';
import '../widgets/text_widget.dart';

class MainScreen extends StatefulWidget {
  MainScreen({Key? key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  bool likeDone = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<UserAuth>(builder: (context, userAuth, child) {
      //   DataProvider dataProvider = Provider.of<DataProvider>(context);

      return Scaffold(
        extendBody: true,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Container(
          height: 70,
          width: 70,
          child: FloatingActionButton(
            heroTag: null,
            shape: CircleBorder(),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PostScreen()),
              );
            },
            child: const Icon(Icons.add),
          ),
        ),
        bottomNavigationBar: BottomAppBarWidget(),
        body: Consumer<DataProvider>(
          builder: (context, dataProvider, child) {
            //dataProvider.startPostStream(FirebaseAuth.instance.currentUser!.uid);

            return ListView.builder(
              itemCount: dataProvider.posts.length,
              itemBuilder: (context, index) {
                PostModel post = dataProvider.posts[index];

                // Fetch the user data based on the post UID
                UserDataModel? postOwner =
                    dataProvider.usersList.firstWhereOrNull(
                  (user) => user.id == post.uid,
                );

                return Card(
                  elevation: 3.0,
                  margin: EdgeInsets.all(8.0),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            ClipOval(
                              child: Image.network(
                                postOwner?.url ?? '',
                                fit: BoxFit.cover,
                                width: 50,
                              ),
                            ),
                            Gap(10),
                            Text(postOwner?.fullname ?? ''),
                          ],
                        ),
                        Gap(10),
                        Container(
                          child: Column(
                            children: [
                              (post.postImg != null)
                                  ? Image.network(post.postImg!)
                                  : Image.asset(
                                      Constants.logoImage,
                                      height: 110,
                                      width: 110,
                                      fit: BoxFit.cover,
                                    ),
                              Row(
                                children: [
                                  TextWidget(
                                    color: CColors.grey5,
                                    size: 15,
                                    text: 'Description:',
                                    fontWeight: FontWeight.normal,
                                  ),
                                  Text(post.text),
                                ],
                              ),
                              Row(
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        likeDone = dataProvider.likePost(
                                            post.id!, Constants.currentID);
                                      },
                                      icon: Icon(
                                        Icons.thumb_up,
                                        color: post.likes
                                                .contains(Constants.currentID)
                                            ? Colors.blue
                                            : Colors.black,
                                      )),
                                  Gap(10),
                                  Text('${post.likes.length}'),
                                  TextButtonWidget(
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    PostDetailsPage(
                                                      post: post,
                                                    )));
                                      },
                                      text: 'Likes and Comments',
                                      color: CColors.grey5,
                                      fontSize: 15,
                                      withIcon: true,
                                      icon: Icon(Icons.people_outline))
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      );
    });
  }
}
