import 'package:flutter/material.dart';

part './kind/dark_color.dart';
part './kind/light_color.dart';

class _AppColors {
  final Color white = const Color(0xffffffff);
  final Color mediumGrey = const Color(0xffa6bcd0);
  final Color mediumGreyBold = const Color(0xff748a9d);
  final Color mediumdGreyBold = const Color(0xff9E9E9E);
  final Color? smallGrey = Colors.grey[200];
  final Color mediumderGreyBold = const Color(0xff616161);
  final Color lighterGrey = const Color(0xfff0f4f8);
  final Color lightGrey = const Color(0xffdbe2ed);
  final Color darkerGrey = const Color(0xff404e5a);
  final Color darkGrey = const Color(0xff4e5d6a);
  final Color red = const Color(0xffd32f2f);
  final Color green = const Color(0xff4CAF50);
  final Color green2 = Color(0xff43A047);
  final Color purplish = Color(0xff6c63ff);
  final Color darkColorForTrial = Color(0xff2e2e2e);
  final Color appBarBlack = Color(0xff424242);

  final Color black = Color(0xff000000);
}

abstract class IColors {
  _AppColors get colors;

  Color? scaffoldBackgroundColor;
  Color? appBarColor;
  Color? tabBarColor;
  Color? tabbarSelectedColor;
  Color? tabbarNormalColor;
  Brightness? brightness;
  ColorScheme? colorScheme;
}
