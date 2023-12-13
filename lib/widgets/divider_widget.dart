import 'package:flutter/material.dart';

class DividerWidget extends StatelessWidget {
  const DividerWidget(
      {super.key,
      required this.end,
      required this.start,
      required this.thickness,
      required this.height,
      required this.color});

  final double end, start, thickness, height;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Divider(
      endIndent: end,
      thickness: thickness,
      color: color,
      indent: start,
      height: height,
    );
  }
}
