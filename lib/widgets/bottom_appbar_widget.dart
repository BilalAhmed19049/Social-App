import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:social_app/screens/chat_screen.dart';
import 'package:social_app/screens/settings_screen.dart';

import '../screens/search_screen.dart';

class BottomAppBarWidget extends StatelessWidget {
  const BottomAppBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      height: 70,
      shape: CircularNotchedRectangle(),
      notchMargin: 8,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          buildTabItem(Icon(Icons.home), () {}),
          //Gap(3),
          buildTabItem(Icon(Icons.chat_outlined), () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => ChatScreen()));
          }),
          Gap(10),
          buildTabItem(Icon(Icons.search), () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => SearchScreen()));
          }),
          //Gap(3),
          buildTabItem(Icon(Icons.settings), () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => SettingsScreen()));
          }),
        ],
      ),
    );
  }

  Widget buildTabItem(Icon icon, final VoidCallback onPressed) {
    return IconButton(
      onPressed: onPressed,
      icon: icon,
      iconSize: 30,
    );
  }
}
