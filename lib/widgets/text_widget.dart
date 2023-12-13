import 'package:flutter/cupertino.dart';

class TextWidget extends StatelessWidget {
  const TextWidget(
      {super.key,
      required this.color,
      required this.size,
      required this.text,
      required this.fontWeight});

  final Color color;
  final double size;
  final String text;
  final FontWeight fontWeight;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontWeight: fontWeight,
        fontSize: size,
        color: color,
      ),
    );
  }
}
