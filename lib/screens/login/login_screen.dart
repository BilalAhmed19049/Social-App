import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:social_app/screens/main_screen.dart';
import 'package:social_app/screens/signup/signup_screen.dart';
import 'package:social_app/utils/helper_functions.dart';
import 'package:social_app/widgets/password_field_widget.dart';
import 'package:social_app/widgets/textfield_widget.dart';

import '../../models/user_data_model.dart';
import '../../providers/userauth_provider.dart';
import '../../utils/colors.dart';
import '../../widgets/elevated_button_widget.dart';
import '../../widgets/text_button_widget.dart';
import '../../widgets/text_widget.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

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
            Fields(), // Widget for 1 textwidget and 2 textfields

            ElevatedButtonWidget(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  bool signInSuccessful = await userAuth.logIn(
                      context: context,
                      userData: UserDataModel(
                        email: emailController.text,
                        password: passwordController.text,
                        fullname: null,
                        id: null,
                        address: null,
                        country: null,
                        phonenumber: null,
                        url: null,
                        isOnline: false,
                        lastActive: '',
                      ));
                  if (signInSuccessful) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MainScreen(),
                      ),
                    );
                  }
                }

                passwordController.clear();
                emailController.clear();
              },
              text: 'LOGIN',
              buttonColor: CColors.t3,
            ),

            signupBtn(context), //signUp text button
          ],
        ),
      ),
    );
  }

  Widget Fields() {
    return Form(
      key: _formKey,
      child: Column(
        //mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextWidget(
            color: CColors.grey8,
            size: 30,
            text: 'Login to your Acocunt',
            fontWeight: FontWeight.bold,
          ),
          Gap(30),
          TextWidget(
              color: CColors.grey8,
              size: 16,
              text: 'Email',
              fontWeight: FontWeight.normal),
          TextFieldWidget(
            validator: HelperFunctions.emailValidation,
            labelText: '',
            controller: emailController,
            fillColor: CColors.grey3,
            textColor: CColors.t4,
            hintText: '',
            isObscure: false,
          ),
          Gap(10),
          TextWidget(
              color: CColors.grey8,
              size: 16,
              text: 'Password',
              fontWeight: FontWeight.normal),
          PasswordFieldWidget(
            validator: HelperFunctions.passwordValidation,
            labelText: '',
            controller: passwordController,
            fillColor: CColors.grey3,
            textColor: CColors.t4,
            hintText: '',
            isObscure: true,
          ),
          Gap(20),
        ],
      ),
    );
  }

  Widget signupBtn(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButtonWidget(
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (ctx) => SignupScreen()));
            passwordController.clear();
            emailController.clear();
          },
          text: 'SignUp',
          color: CColors.grey8,
          fontSize: 16,
          withIcon: true,
          icon: Icon(
            Icons.person_add,
            color: CColors.white,
          ),
        ),
      ],
    );
  }
}
