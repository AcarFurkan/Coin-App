import 'package:flutter/material.dart';

class DecoratedTabBar extends StatelessWidget implements PreferredSizeWidget {
  const DecoratedTabBar(
      {Key? key, required this.tabBar, required this.decoration})
      : super(key: key);
  final TabBar tabBar;
  final BoxDecoration decoration;
  @override
  Size get preferredSize => tabBar.preferredSize;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(child: Container(decoration: decoration)),
        tabBar
      ],
    );
  }
}
