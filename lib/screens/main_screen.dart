import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:social_app/providers/comment_provider.dart';
import 'package:social_app/providers/data_provider.dart';
import 'package:social_app/screens/all_chats_screen.dart';
import 'package:social_app/screens/post_details_page.dart';
import 'package:social_app/screens/post_upload_screen.dart';
import 'package:social_app/screens/search_screen.dart';
import 'package:social_app/screens/settings_screen.dart';
import 'package:social_app/widgets/bottom_appbar_widget.dart';
import 'package:social_app/widgets/text_button_widget.dart';
import 'package:social_app/widgets/text_widget.dart';

import '../models/comment_model.dart';
import '../models/post_model.dart';
import '../models/user_data_model.dart';
import '../providers/userauth_provider.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';

class MainScreen extends StatefulWidget {
  MainScreen({Key? key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        children: [
          buildPage(PostListScreen()),
          buildPage(AllChatScreen()),
          buildPage(SearchScreen()),
          buildPage(SettingsScreen()),
        ],
      ),
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
      bottomNavigationBar: BottomAppBarWidget(
        currentIndex: _currentIndex,
        onTap: (index) {
          _pageController.animateToPage(
            index,
            duration: Duration(milliseconds: 100),
            curve: Curves.easeInOut,
          );
        },
      ),
    );
  }

  Widget buildPage(Widget page) {
    return Container(
      color: Colors.grey[200],
      child: page,
    );
  }
}

class PostListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<UserAuth>(builder: (context, userAuth, child) {
      return Consumer<CommentProvider>(
        builder: (context, commentProvider, child) {
          return Consumer<DataProvider>(
            builder: (context, dataProvider, child) {
              return ListView.builder(
                itemCount: dataProvider.posts.length,
                itemBuilder: (context, index) {
                  PostModel post = dataProvider.posts[index];
                  List<CommentModel> postComments = commentProvider.comments
                      .where((comment) => comment.postId == post.id)
                      .toList();

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
                                Gap(5),
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
                                        dataProvider.likePost(
                                          post.id!,
                                          Constants.currentID,
                                        );
                                      },
                                      icon: Icon(
                                        Icons.thumb_up,
                                        color: post.likes
                                                .contains(Constants.currentID)
                                            ? CColors.t5
                                            : Colors.black,
                                      ),
                                    ),
                                    Text('${post.likes.length} '),
                                    TextButtonWidget(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                PostDetailsPage(
                                              post: post,
                                            ),
                                          ),
                                        );
                                      },
                                      text: 'Likes & Comments',
                                      color: CColors.black,
                                      fontSize: 13,
                                      withIcon: false,
                                      icon: Icon(Icons.comment),
                                    ),
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
          );
        },
      );
    });
  }
}
