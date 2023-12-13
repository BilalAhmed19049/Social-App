import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:social_app/providers/userauth_provider.dart';
import 'package:social_app/screens/details_screen.dart';

import '../utils/colors.dart';
import '../utils/constants.dart';
import '../widgets/elevated_button_widget.dart';
import '../widgets/text_widget.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserAuth>(builder: (context, userAuth, child) {
      return Scaffold(
        backgroundColor: CColors.backgroundColor,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              //mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: (userAuth.userData?.url != null &&
                          userAuth.userData?.url != "")
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
                TextWidget(
                    color: CColors.grey8,
                    size: 18,
                    text: '${userAuth.userData!.fullname} ',
                    fontWeight: FontWeight.bold),
                IntrinsicHeight(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextWidget(
                          color: CColors.grey8,
                          size: 15,
                          text: '${userAuth.userData!.country} ',
                          fontWeight: FontWeight.normal),
                      VerticalDivider(
                        color: CColors.dpurple,
                        thickness: 3,
                        indent: 3,
                        endIndent: 3,
                      ),
                      TextWidget(
                          color: CColors.grey8,
                          size: 15,
                          text: '${userAuth.userData!.email} ',
                          fontWeight: FontWeight.normal),
                    ],
                  ),
                ),
                Gap(10),
                ElevatedButtonWidget(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (ctx) => DetailsScreen(
                                  comingFromProfile: true,
                                )));
                  },
                  text: 'Edit Profile',
                  buttonColor: CColors.t4,
                ),

                //TextButtonWidget(onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (ctx)=>DetailsScreen()));  }, text: 'View Profile', color: CColors.white, fontSize: 20, withIcon: true, icon: Icon(Icons.add),),
              ],
            ),
          ),
        ),
      );
    });
  }
}
