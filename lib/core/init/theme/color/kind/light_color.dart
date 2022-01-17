part of '../color_manager.dart';

class LightColors implements IColors {
  @override
  final _AppColors colors = _AppColors();

  @override
  Color? appBarColor;

  @override
  Brightness? brightness;

  @override
  ColorScheme? colorScheme;

  @override
  Color? scaffoldBackgroundColor;

  @override
  Color? tabBarColor;

  @override
  Color? tabbarNormalColor;

  @override
  Color? tabbarSelectedColor;

  LightColors() {
    appBarColor = colors.white;
    scaffoldBackgroundColor = colors.smallGrey;
    tabBarColor = colors.mediumGrey;
    tabbarNormalColor = colors.mediumdGreyBold;
    tabbarSelectedColor = colors.darkerGrey;
    colorScheme = ColorScheme.light().copyWith(
      primary: colors.darkGrey,
      onPrimary: colors.darkerGrey,
      primaryVariant: colors.lighterGrey,
      secondary: colors.mediumGrey,
      onSecondary: colors.mediumGreyBold,
      secondaryVariant: colors.lightGrey,
      background: colors.white,
      error: colors.red,
      onSurface: colors.mediumGreyBold,
      onBackground: colors.black,
      onError: colors.white,
      surface: colors.green,
      brightness: Brightness.light,
    );
    brightness = Brightness.light;
  }
}
