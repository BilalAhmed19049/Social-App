import 'package:flutter/material.dart';

import '../utils/colors.dart';

class TextFieldWidget extends StatelessWidget {
   TextFieldWidget({
    super.key,
    required this.labelText,
    required this.controller,
    required this.fillColor,
    required this.textColor,
    required this.hintText,
    this.validator,
    required this.isObscure,
  });

  final String labelText;
  final Color fillColor;
  final Color textColor;
  final String hintText;
  final String? Function(String?)? validator;
  bool isObscure = false;

  // final double height;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: height,

      child: TextFormField(
        obscureText: isObscure,
        validator: validator,
        controller: controller,
        style: TextStyle(
          color: CColors.t5,
        ),
        decoration: InputDecoration(
          isDense: true,
          filled: true,
          fillColor: fillColor,
          border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(30)),
               borderSide: BorderSide(
                 width: 2,
               )),
           labelText: labelText,
           hintText: hintText,
           labelStyle: TextStyle(color: textColor),
           errorStyle: TextStyle(color: CColors.grey8),
         ),
      ),
    );
  }
}
