import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:social_app/models/post_model.dart';
import 'package:social_app/providers/data_provider.dart';
import 'package:social_app/providers/userauth_provider.dart';
import 'package:social_app/screens/main_screen.dart';
import 'package:social_app/widgets/elevated_button_widget.dart';
import 'package:social_app/widgets/textfield_widget.dart';

import '../utils/colors.dart';
import '../utils/constants.dart';

class PostScreen extends StatelessWidget {
  const PostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController descriptionController = TextEditingController();
    UserAuth userAuth = UserAuth();
    return Consumer<DataProvider>(builder: (context, dataProvider, child) {
      return Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  children: [
                    (dataProvider.pickedImage != null)
                        ? Container(
                            child: (dataProvider.pickedImage == null)
                                ? Image.asset(
                                    Constants.logoImage,
                                    height: 200,
                                    width: 200,
                                    fit: BoxFit.cover,
                                  )
                                : Image.file(
                                    dataProvider.pickedImage!,
                                    height: 200,
                                    width: 200,
                                    fit: BoxFit.cover,
                                  ),
                          )
                        : Container(
                            child: Image.network(
                              dataProvider.post?.postImg ??
                                  "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png",
                              height: 200,
                              width: 200,
                              fit: BoxFit.cover,
                            ),
                          ),
                    Positioned(
                      bottom: -5,
                      right: -12,
                      child: IconButton(
                        icon: Icon(
                          size: 30,
                          Icons.upload_file,
                          color: CColors.t5,
                        ),
                        onPressed: () {
                          dataProvider.pickPost();
                        },
                      ),
                    ),
                  ],
                ),
                Gap(40),
                TextFieldWidget(
                    labelText: 'Post Description',
                    controller: descriptionController,
                    fillColor: CColors.grey3,
                    textColor: CColors.black,
                    hintText: ''),
                Gap(40),
                Center(
                    child: ElevatedButtonWidget(
                        onPressed: () async {
                          if (dataProvider.pickedImage != null) {
                            String imageUrl = await dataProvider
                                .uploadPost(dataProvider.pickedImage!);
                            if (userAuth.userData != null) {
                              PostModel post = PostModel(
                                name: userAuth.userData!.fullname,
                                postImg: imageUrl,
                                uid: userAuth.userData!.id!,
                                text: descriptionController.text.trim(),
                                id: null,
                              );
                              bool postSuccessful =
                                  await dataProvider.savePost(post);
                              if (postSuccessful) {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (ctx) => MainScreen()));
                              }
                            } else {
                              // Handle the error here
                              print(
                                  'Error: userData or descriptionController is null');
                            }
                          }
                        },
                        text: 'Post',
                        buttonColor: CColors.t4)),
              ],
            ),
          ),
        ),
      );
    });
  }
}
