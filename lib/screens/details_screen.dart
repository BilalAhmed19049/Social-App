import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:social_app/screens/main_screen.dart';

import '../providers/userauth_provider.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';
import '../utils/helper_functions.dart';
import '../widgets/elevated_button_widget.dart';
import '../widgets/text_widget.dart';
import '../widgets/textfield_widget.dart';

class DetailsScreen extends StatefulWidget {
  final bool comingFromProfile;

  DetailsScreen({super.key, required this.comingFromProfile});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Consumer<UserAuth>(builder: (context, userAuth, child) {
      bool detailsAdded = false;
      nameController.text = userAuth.userData?.fullname ??
          ''; //populating all the fields with user data from firebase
      addressController.text = userAuth.userData?.address ?? '';
      countryController.text = userAuth.userData?.country ?? '';
      phoneNumberController.text = userAuth.userData?.phonenumber ?? '';

      return Scaffold(
        backgroundColor: CColors.t4,
        body: SingleChildScrollView(
          child: Padding(
              padding: EdgeInsets.all(25),
              child: SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextWidget(
                      color: CColors.white,
                      size: 30,
                      text: 'Please enter your details',
                      fontWeight: FontWeight.normal,
                    ),
                    Gap(20),
                    Center(
                      child: photo(userAuth), //user photo
                    ),
                    Gap(20),

                    Fields(), // all fields

                    ElevatedButtonWidget(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          if (userAuth.pickedImage != null) {
                            String imageUrl = await userAuth
                                .uploadImage(userAuth.pickedImage!);
                            userAuth.imageUrl = imageUrl;
                            Map<String, dynamic> updatedUserData = {
                              'fullname': nameController.text,
                              'number': phoneNumberController.text,
                              'address': addressController.text,
                              'country': countryController.text,
                              'url': userAuth.imageUrl,
                            };
                            bool dataUpdated = await userAuth.updateData(
                                updatedUserData,
                                Constants.auth.currentUser!.uid,
                                context);
                            if (dataUpdated) {
                              detailsAdded = true; // Set detailsAdded to true

                              // Save the state in shared preferences
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              prefs.setBool('detailsAdded',
                                  detailsAdded); //making bool value true after data update

                              HelperFunctions.showSnackBar(
                                  context, 'Data Updated');
                              await Future.delayed(Duration(seconds: 3));
                              await Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (ctx) => MainScreen()));
                              detailsAdded = true;
                            }
                          } else {
                            HelperFunctions.showSnackBar(
                                context, '{Pick Image}');
                          }
                        }
                      },
                      text: 'Update',
                      buttonColor: CColors.t3,
                    ),
                  ],
                ),
              )),
        ),
      );
    });
  }

  Widget photo(UserAuth userAuth) {
    return Stack(
      children: [
        (userAuth.userData?.url == null || userAuth.pickedImage != null)
            ? ClipOval(
                child: (userAuth.pickedImage == null)
                    ? Image.asset(
                        Constants.logoImage,
                        height: 130,
                        width: 130,
                        fit: BoxFit.cover,
                      )
                    : Image.file(
                        userAuth.pickedImage!,
                        height: 130,
                        width: 130,
                        fit: BoxFit.cover,
                      ),
              )
            : ClipOval(
                child: Image.network(
                  userAuth.userData?.url ?? Constants.logoImage,
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
              size: 30,
              Icons.upload_file,
              color: CColors.black,
            ),
            onPressed: () {
              userAuth.pickImage();
            },
          ),
        ),
      ],
    );
  }

  Widget Fields() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFieldWidget(
            validator: HelperFunctions.generalValidation,
            labelText: 'Username',
            // height: 51,
            controller: nameController,
            fillColor: CColors.grey3,
            textColor: CColors.t4,
            hintText: '',
          ),
          Gap(10),
          TextFieldWidget(
            validator: HelperFunctions.generalValidation,
            labelText: 'Address',
            // height: 51,
            controller: addressController,
            fillColor: CColors.grey3,
            textColor: CColors.t4,
            hintText: '',
          ),
          Gap(10),
          TextField(
            controller: countryController,
            readOnly: true,
            onTap: () {
              HelperFunctions.pickCountry(context, countryController);
            },
            decoration: InputDecoration(
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(40)),
                borderSide: BorderSide(
                  width: 2,
                ),
              ),
              fillColor: CColors.grey3,
              filled: true,
              labelText: 'Country',
              labelStyle: TextStyle(color: CColors.t5),
            ),
          ),
          Gap(10),
          TextFieldWidget(
            validator: HelperFunctions.generalValidation,
            labelText: 'Phone Number',

            // height: 51,
            controller: phoneNumberController,
            fillColor: CColors.grey3,
            textColor: CColors.t4,
            hintText: '',
          ),
          Gap(30),
        ],
      ),
    );
  }
}
