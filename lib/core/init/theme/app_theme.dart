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
  static ThemeData craeteTheme(ITheme theme) {
    if (theme is AppThemeDark) {
      return ThemeData.dark().copyWith(
        textTheme: theme.textTheme.data,
        colorScheme: theme.colors.colorScheme,
        appBarTheme: AppBarTheme(color: theme.colors.colors.appBarBlack),
        //bottomAppBarColor: theme.colors.colors.darkColorForTrial,
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
            backgroundColor: theme.colors.colors.darkColorForTrial,
            selectedItemColor: theme.colors.colors.white,
            unselectedItemColor: theme.colors.colors.mediumdGreyBold,
            selectedIconTheme: IconThemeData(color: theme.colors.colors.white)),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
            backgroundColor: theme.colors.colors.purplish,
            foregroundColor: theme.colors.colors.white),
        tabBarTheme: TabBarTheme(
          indicator: const BoxDecoration(),
          labelColor: theme.colors.tabbarSelectedColor,
          unselectedLabelColor: theme.colors.tabbarNormalColor,
        ),
        canvasColor: theme.colors.colors.purplish,
        backgroundColor: Colors.red,
        inputDecorationTheme: InputDecorationTheme(
          contentPadding: EdgeInsets.symmetric(
            vertical: 22,
            horizontal: 26,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25.0),
            borderSide: BorderSide(
              color: theme.colors.colorScheme!.onError,
            ),
          ),
          labelStyle: TextStyle(color: theme.colors.colorScheme?.onBackground),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25.0),
            borderSide: BorderSide(
              color: theme.colors.colorScheme!.onError,
            ),
          ),
          iconColor: theme.colors.colorScheme?.onError,

          /*labelStyle: TextStyle(
          fontSize: 15,
          decorationColor: Colors.red,
        ),*/
        ),
        cardTheme: CardTheme(elevation: 10),
        outlinedButtonTheme: OutlinedButtonThemeData(
            style: ButtonStyle(
                textStyle: MaterialStateProperty.all<TextStyle>(
                    theme.textTheme.data.button!),
                shape: MaterialStateProperty.all<OutlinedBorder?>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20))),
                foregroundColor:
                    MaterialStateProperty.all(theme.colors.colors.white),
                backgroundColor:
                    MaterialStateProperty.all(theme.colors.colors.purplish))),
      );
    } else {
      return ThemeData.light().copyWith(
        floatingActionButtonTheme: FloatingActionButtonThemeData(
            backgroundColor: theme.colors.colors.purplish,
            foregroundColor: theme.colors.colors.white),
        cardTheme: CardTheme(elevation: 3),
        appBarTheme: AppBarTheme(backgroundColor: theme.colors.appBarColor),
        iconTheme: IconThemeData(color: theme.colors.colors.darkerGrey),
        primaryIconTheme: IconThemeData(color: theme.colors.colors.darkGrey),
        scaffoldBackgroundColor: theme.colors.scaffoldBackgroundColor,
        colorScheme: theme.colors.colorScheme,
        textTheme: theme.textTheme.data,
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
            backgroundColor: theme.colors.colors.darkerGrey,
            selectedItemColor: theme.colors.colors.white,
            unselectedItemColor: theme.colors.colors.mediumdGreyBold,
            selectedIconTheme: IconThemeData(color: Colors.white)),
        tabBarTheme: TabBarTheme(
          indicator: const BoxDecoration(),
          labelColor: theme.colors.tabbarSelectedColor,
          unselectedLabelColor: theme.colors.tabbarNormalColor,
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
        outlinedButtonTheme: OutlinedButtonThemeData(
            style: ButtonStyle(
                textStyle: MaterialStateProperty.all<TextStyle>(
                    theme.textTheme.data.button!),
                shape: MaterialStateProperty.all<OutlinedBorder?>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20))),
                foregroundColor:
                    MaterialStateProperty.all(theme.colors.colors.white),
                backgroundColor:
                    MaterialStateProperty.all(theme.colors.colors.purplish))),
        canvasColor: theme.colors.colors.purplish,
        radioTheme: RadioThemeData(
            fillColor: MaterialStateProperty.all(theme.colors.colors.darkGrey)),
      );
    }
    return ThemeData(
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
            backgroundColor: theme.colors.colors.purplish),
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
}

class AppThemeDark extends ITheme {
  @override
  late final ITextTheme textTheme;
  AppThemeDark() {
    textTheme = TextThemeDark(colors.colors.white);
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
