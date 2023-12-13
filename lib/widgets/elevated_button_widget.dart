import 'package:flutter/material.dart';

class ElevatedButtonWidget extends StatelessWidget {
  const ElevatedButtonWidget({
    Key? key,
    required this.onPressed,
    required this.text,
    required this.buttonColor,
  }) : super(key: key);

  final VoidCallback onPressed;
  final String text;
  final Color buttonColor;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: buttonColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        // Set the background color of the button
        minimumSize: Size(double.infinity, 50),
      ),
      child: Text(
        text,
        style:
            TextStyle(color: Colors.white), // Set the text color of the button
      ),
    );
  }
}
