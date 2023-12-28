import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:social_app/providers/userauth_provider.dart';
import 'package:social_app/screens/login/login_screen.dart';
import 'package:social_app/screens/profile_screen.dart';
import 'package:social_app/widgets/elevated_button_widget.dart';

import '../utils/colors.dart';
import '../utils/constants.dart';
import '../widgets/divider_widget.dart';
import '../widgets/text_button_widget.dart';
import '../widgets/text_widget.dart';
import 'friends_requests_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserAuth>(builder: (context, userAuth, child) {
      return Scaffold(
        backgroundColor: CColors.backgroundColor,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                profile(userAuth, context),
                //widget showing profile pivture and name
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButtonWidget(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (ctx) => ProfileScreen()),
                        );
                      },
                      text: 'View Profile',
                      color: Colors.deepPurple,
                      fontSize: 18,
                      withIcon: true,
                      icon: Icon(Icons.add),
                    ),
                  ],
                ),
                buttons(userAuth, context),
                //  widget showing buttons
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget profile(UserAuth userAuth, BuildContext context) {
    return Column(
      children: [
        Center(
          child:
              (userAuth.userData?.url != null && userAuth.userData?.url != "")
                  ? ClipOval(
                      child: Image.network(
                        userAuth.userData?.url ?? Constants.logoImage,
                        height: 110,
                        width: 110,
                        fit: BoxFit.cover,
                      ),
                    )
                  : ClipOval(
                      child: Image.asset(
                        Constants.logoImage,
                        height: 110,
                        width: 110,
                        fit: BoxFit.cover,
                      ),
                    ),
        ),
        Gap(5),
        TextWidget(
          color: CColors.grey8,
          size: 15,
          text: '${userAuth.userData?.fullname} ',
          fontWeight: FontWeight.normal,
        ),
      ],
    );
  }

  Widget buttons(UserAuth userAuth, BuildContext context) {
    return Column(
      children: [
        Gap(10),
        DividerWidget(
          end: 0,
          start: 0,
          thickness: 1,
          height: 0,
          color: CColors.grey8,
        ),
        Gap(10),
        ElevatedButtonWidget(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (ctx) => FriendsRequestsPage()));
            },
            text: 'Friends',
            buttonColor: CColors.t4),
        Gap(10),
        DividerWidget(
          end: 0,
          start: 0,
          thickness: 1,
          height: 0,
          color: CColors.grey8,
        ),
        Gap(10),
        ElevatedButtonWidget(
          onPressed: () async {
            bool logout = await userAuth.logOut();
            if (logout) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (ctx) => LoginScreen()),
              );
            }
          },
          text: 'Logout',
          buttonColor: CColors.t4,
        ),
        Gap(10),
        DividerWidget(
          end: 0,
          start: 0,
          thickness: 1,
          height: 0,
          color: CColors.grey8,
        ),
        Gap(10),
      ],
    );
  }
}
