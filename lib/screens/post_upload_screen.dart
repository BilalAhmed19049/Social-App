import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:social_app/models/post_model.dart';
import 'package:social_app/providers/data_provider.dart';
import 'package:social_app/providers/userauth_provider.dart';
import 'package:social_app/screens/main_screen.dart';
import 'package:social_app/widgets/elevated_button_widget.dart';
import 'package:social_app/widgets/text_button_widget.dart';

import '../utils/colors.dart';
import '../utils/constants.dart';
import '../widgets/description_textfield_widget.dart';

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
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Stack(
                    children: [
                      (dataProvider.pickedImage != null)
                          ? Container(
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(color: CColors.t5, width: 2)),
                              child: (dataProvider.pickedImage == null)
                                  ? Image.asset(
                                      Constants.logoImage,
                                      // height: 200,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    )
                                  : Image.file(
                                      dataProvider.pickedImage!,
                                      // height: 200,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                            )
                          : Container(
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.teal, width: 2),
                              ),
                              child: Image.network(
                                dataProvider.post?.postImg ??
                                    "https://images.unsplash.com/photo-1512314889357-e157c22f938d?q=80&w=2071&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                                // height: 200,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                      // Positioned(
                      //   bottom: -5,
                      //   right: -10,
                      //   child: IconButton(
                      //     icon: Icon(
                      //       size: 30,
                      //       Icons.upload_file,
                      //       color: CColors.red7,
                      //     ),
                      //     onPressed: () {
                      //       dataProvider.pickPost();
                      //     },
                      //   ),
                      // ),
                    ],
                  ),
                  TextButtonWidget(
                      onPressed: () => dataProvider.pickPost(),
                      text: 'Select post',
                      color: CColors.t5,
                      fontSize: 14,
                      withIcon: false,
                      icon: Icon(Icons.post_add)),
                  Gap(40),
                  DescriptionTextFieldWidget(
                      labelText: 'Post Description',
                      controller: descriptionController,
                      fillColor: Colors.transparent,
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
        ),
      );
    });
  }
}
