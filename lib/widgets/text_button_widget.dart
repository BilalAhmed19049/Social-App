import 'package:flutter/material.dart';

class TextButtonWidget extends StatelessWidget {
  TextButtonWidget(
      {super.key,
      required this.onPressed,
      required this.text,
      required this.color,
      required this.fontSize,
      required this.withIcon,
      required this.icon});

  final VoidCallback onPressed;
  final String text;
  final Color color;
  final double fontSize;
  bool withIcon = false;
  final Icon icon;

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: onPressed,
        child: withIcon
            ? Row(children: [
                Text(
                  text,
                  style: TextStyle(
                    color: color,
                    fontSize: fontSize,
                  ),
                ),
              ])
            : Row(
                children: [
                  icon,
                  Text(
                    text,
                    style: TextStyle(
                      color: color,
                      fontSize: fontSize,
                    ),
                  ),
                ],
              ));
  }
}
