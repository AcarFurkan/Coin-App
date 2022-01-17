import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../text_theme.dart';

class TextThemeDark implements ITextTheme {
  @override
  Color? primaryColor;

  @override
  late TextTheme data;

  @override
  TextStyle? bodyText1;

  @override
  TextStyle? bodyText2;

  @override
  String? fontFamily;

  @override
  TextStyle? headline1;

  @override
  TextStyle? headline3;

  @override
  TextStyle? headline4;

  @override
  TextStyle? headline5;

  @override
  TextStyle? headline6;

  @override
  TextStyle? subtitle1;

  @override
  TextStyle? subtitle2;

  TextThemeDark(this.primaryColor) {
    data = TextTheme(
      headline1: GoogleFonts.notoSans(
          color: primaryColor,
          fontSize: 96,
          fontWeight: FontWeight.w300,
          letterSpacing: -1.5),
      headline2: GoogleFonts.notoSans(
          color: primaryColor,
          fontSize: 60,
          fontWeight: FontWeight.w300,
          letterSpacing: -0.5),
      headline3:
          GoogleFonts.notoSans(fontSize: 48, fontWeight: FontWeight.w400),
      headline4: GoogleFonts.notoSans(
          color: primaryColor,
          fontSize: 34,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.25),
      headline5: GoogleFonts.roboto(
          color: primaryColor, fontSize: 24, fontWeight: FontWeight.w400),
      headline6: GoogleFonts.notoSans(
          color: primaryColor,
          fontSize: 20,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.15),
      subtitle1: GoogleFonts.notoSans(
          color: primaryColor,
          fontSize: 16,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.15),
      subtitle2: GoogleFonts.notoSans(
          color: primaryColor,
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.1),
      bodyText1: GoogleFonts.notoSans(
          color: primaryColor,
          fontSize: 16,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.5),
      bodyText2: GoogleFonts.notoSans(
          color: primaryColor,
          fontSize: 14,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.25),
      button: GoogleFonts.notoSans(
          color: primaryColor,
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 1.25),
      caption: GoogleFonts.notoSans(
          color: primaryColor,
          fontSize: 12,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.4),
      overline: GoogleFonts.notoSans(
          color: primaryColor,
          fontSize: 10,
          fontWeight: FontWeight.w400,
          letterSpacing: 1.5),
    ).apply(
      fontFamily: GoogleFonts.notoSans().fontFamily,
      bodyColor: primaryColor,
    );

    fontFamily = GoogleFonts.notoSans().fontFamily;
  }
}
