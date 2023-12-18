import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class BottomAppBarWidget extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomAppBarWidget({required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      height: 70,
      shape: CircularNotchedRectangle(),
      notchMargin: 8,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          buildTabItem(Icon(Icons.home), 0),
          buildTabItem(Icon(Icons.chat_outlined), 1),
          Gap(10),
          buildTabItem(Icon(Icons.search), 2),
          buildTabItem(Icon(Icons.settings), 3),
        ],
      ),
    );
  }

  Widget buildTabItem(Icon icon, int index) {
    return IconButton(
      onPressed: () => onTap(index),
      icon: icon,
      iconSize: 30,
      color: currentIndex == index ? Colors.teal : Colors.black,
    );
  }
}
