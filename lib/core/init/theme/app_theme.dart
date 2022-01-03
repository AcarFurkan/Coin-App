import 'package:flutter/material.dart';

import 'color/color_manager.dart';
import 'text/kind/dark_text.dart';
import 'text/kind/light_text.dart';
import 'text/text_theme.dart';

abstract class ITheme {
  ITextTheme get textTheme;
  IColors get colors;
}

abstract class ThemeManager {
  static ThemeData craeteTheme(ITheme theme) => ThemeData(
      fontFamily: theme.textTheme.fontFamily,
      textTheme: theme.textTheme.data,
      cardColor: theme.colors.colorScheme?.background,
      bottomAppBarColor: theme.colors.colorScheme!.onPrimary,
      tabBarTheme: TabBarTheme(
        indicator: const BoxDecoration(),
        labelColor: theme.colors.tabbarSelectedColor,
        unselectedLabelColor: theme.colors.tabbarNormalColor,
      ),

      //buttonTheme: ButtonThemeData(buttonColor: Colors.amber),
      outlinedButtonTheme: OutlinedButtonThemeData(
          style: ButtonStyle(
              shape: MaterialStateProperty.all<OutlinedBorder?>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20))),
              foregroundColor:
                  MaterialStateProperty.all(theme.colors.colors.white),
              backgroundColor:
                  MaterialStateProperty.all(theme.colors.colors.purplish))),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
          foregroundColor: theme.colors.colors.white,
          backgroundColor: theme.colors.colors.mediumGreyBold),
      appBarTheme: AppBarTheme(
        backgroundColor: theme.colors.appBarColor,
      ),
      inputDecorationTheme: InputDecorationTheme(
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.0),
          borderSide: BorderSide(
            color: theme.colors.colorScheme!.primary,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.0),
          borderSide: BorderSide(
            color: theme.colors.colorScheme!.primary,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.0),
          borderSide: BorderSide(color: Colors.black),
        ),
        contentPadding: EdgeInsets.symmetric(
          vertical: 22,
          horizontal: 26,
        ),

        /*labelStyle: TextStyle(
          fontSize: 15,
          decorationColor: Colors.red,
        ),*/
      ),
      iconTheme: IconThemeData(color: theme.colors.colors.darkerGrey),
      primaryIconTheme: IconThemeData(color: theme.colors.colors.darkGrey),
      scaffoldBackgroundColor: theme.colors.scaffoldBackgroundColor,
      colorScheme: theme.colors.colorScheme);
}

class AppThemeDark extends ITheme {
  @override
  late final ITextTheme textTheme;
  AppThemeDark() {
    textTheme = TextThemeDark(colors.colors.mediumGrey);
  }
  @override
  IColors get colors => DarkColors();
}

class AppThemeLight extends ITheme {
  @override
  late final ITextTheme textTheme;
  AppThemeLight() {
    textTheme = TextThemeLight(colors.colors.darkerGrey);
  }
  @override
  IColors get colors => LightColors();
}
