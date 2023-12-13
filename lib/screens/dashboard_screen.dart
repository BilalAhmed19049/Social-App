import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/userauth_provider.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';
import '../widgets/text_widget.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserAuth>(builder: (context, userAuth, child) {
      return Padding(
        padding: const EdgeInsets.all(30.0),
        child: Scaffold(
            backgroundColor: Colors.black,
            body: Column(children: [
              Stack(
                children: [
                  (userAuth.userData?.url != null &&
                          userAuth.userData?.url != "")
                      ? ClipOval(
                          child: Image.network(
                            userAuth.userData?.url ?? Constants.logoImage,
                            height: 70,
                            width: 70,
                            fit: BoxFit.cover,
                          ),
                        )
                      : ClipOval(
                          child: Image.asset(
                            Constants.logoImage,
                            height: 130,
                            width: 130,
                            fit: BoxFit.cover,
                          ),
                        ),
                  Positioned(
                    bottom: -5,
                    right: -10,
                    child: IconButton(
                      icon: Icon(
                        Icons.cloud_upload,
                        color: Colors.greenAccent.shade400,
                      ),
                      onPressed: () {
                        userAuth.pickImage();
                      },
                    ),
                  ),
                ],
              ),
              //ElevatedButton(onPressed: (){userAuth.getImage(FirebaseAuth.instance.currentUser!.uid);}, child: Text('image')),
              TextWidget(
                  color: CColors.white,
                  size: 22,
                  text: '${userAuth.userData!.fullname} ',
                  fontWeight: FontWeight.bold),

              TextWidget(
                  color: CColors.white,
                  size: 16,
                  text: userAuth.userData!.email,
                  fontWeight: FontWeight.normal),
              //   TextWidget(color: CColors.white, size: 16, text: userAuth.userData!.number, fontWeight: FontWeight.normal),
              TextWidget(
                  color: CColors.white,
                  size: 16,
                  text: userAuth.userData!.address ?? 'Address',
                  fontWeight: FontWeight.normal),
              TextWidget(
                  color: CColors.white,
                  size: 16,
                  text: userAuth.userData!.phonenumber ?? 'Address',
                  fontWeight: FontWeight.normal),
            ])),
      );
    });
  }
}
