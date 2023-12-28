import 'package:flutter/material.dart';

import '../utils/colors.dart';

class PasswordFieldWidget extends StatefulWidget {
  PasswordFieldWidget({
    Key? key,
    required this.labelText,
    required this.controller,
    required this.fillColor,
    required this.textColor,
    required this.hintText,
    this.validator,
    required this.isObscure,
  }) : super(key: key);

  final String labelText;
  final Color fillColor;
  final Color textColor;
  final String hintText;
  final String? Function(String?)? validator;
  bool isObscure;
  final TextEditingController controller;

  @override
  _TextFieldWidgetState createState() => _TextFieldWidgetState();
}

class _TextFieldWidgetState extends State<PasswordFieldWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextFormField(
        obscureText: widget.isObscure,
        validator: widget.validator,
        controller: widget.controller,
        style: TextStyle(
          color: CColors.t5,
        ),
        decoration: InputDecoration(
          isDense: true,
          filled: true,
          fillColor: widget.fillColor,
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(30)),
            borderSide: BorderSide(
              width: 2,
            ),
          ),
          labelText: widget.labelText,
          hintText: widget.hintText,
          labelStyle: TextStyle(color: widget.textColor),
          errorStyle: TextStyle(color: CColors.grey8),
          suffixIcon: widget.isObscure
              ? IconButton(
                  icon: Icon(Icons.visibility),
                  onPressed: () {
                    setState(() {
                      widget.isObscure = !widget.isObscure;
                    });
                  },
                )
              : IconButton(
                  icon: Icon(Icons.visibility_off),
                  onPressed: () {
                    setState(() {
                      widget.isObscure = !widget.isObscure;
                    });
                  },
                ),
        ),
      ),
    );
  }
}
