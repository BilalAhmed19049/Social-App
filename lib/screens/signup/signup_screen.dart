import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:social_app/screens/details_screen.dart';
import 'package:social_app/utils/helper_functions.dart';
import 'package:social_app/widgets/textfield_widget.dart';

import '../../models/user_data_model.dart';
import '../../providers/userauth_provider.dart';
import '../../utils/colors.dart';
import '../../widgets/elevated_button_widget.dart';
import '../../widgets/text_button_widget.dart';
import '../../widgets/text_widget.dart';

class SignupScreen extends StatelessWidget {
  SignupScreen({super.key});

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    UserAuth userAuth = Provider.of<UserAuth>(context);
    return Scaffold(
      backgroundColor: CColors.t4,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Fields(),
            ElevatedButtonWidget(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  bool signUpSuccessful = await userAuth.signUp(
                      userData: UserDataModel(
                          email: emailController.text,
                          password: passwordController.text),
                      context: context);
                  SharedPreferences prefs = await SharedPreferences
                      .getInstance(); //setting bool value false as user signup
                  prefs.setBool('detailsAdded', false);

                  if (signUpSuccessful) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailsScreen(
                          comingFromProfile: false,
                        ),
                      ),
                    );
                  }
                }
              },
              text: 'SINGUP',
              buttonColor: CColors.t3,
            ),
            loginBtn(context),
          ],
        ),
      ),
    );
  }

  Widget Fields() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextWidget(
            color: CColors.grey8,
            size: 30,
            text: 'Create you Account',
            fontWeight: FontWeight.bold,
          ),
          Gap(30),
          TextFieldWidget(
            validator: HelperFunctions.emailValidation,
            labelText: 'Email',
            controller: emailController,
            fillColor: CColors.grey3,
            textColor: CColors.grey8,
            hintText: '',
          ),
          Gap(10),
          TextFieldWidget(
            validator: HelperFunctions.passwordValidation,
            labelText: 'Password',
            controller: passwordController,
            fillColor: CColors.grey3,
            textColor: CColors.grey8,
            hintText: '',
          ),
          Gap(20),
        ],
      ),
    );
  }

  Widget loginBtn(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButtonWidget(
          onPressed: () {
            Navigator.pop(context);
          },
          text: 'SignIn',
          color: CColors.grey8,
          fontSize: 16,
          withIcon: false,
          icon: Icon(
            Icons.person_add,
            color: CColors.grey8,
          ),
        ),
      ],
    );
  }
}
