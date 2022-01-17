part of '../color_manager.dart';

class DarkColors implements IColors {
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

  DarkColors() {
    appBarColor = colors.darkGrey;
    scaffoldBackgroundColor = colors.darkColorForTrial;
    tabBarColor = colors.mediumdGreyBold;
    tabbarNormalColor = colors.mediumdGreyBold;
    tabbarSelectedColor = colors.white;

    colorScheme = ColorScheme.dark().copyWith(
      onPrimary: colors.mediumderGreyBold,
      primary: colors.black,
      onSecondary: colors.darkGrey,
      primaryVariant: colors.white,
      secondaryVariant: colors.darkerGrey,
      surface: colors.green,
      background: colors.darkColorForTrial,
      onBackground: colors.white,
      onError: colors.white,
    );
    brightness = Brightness.dark;
  }
}
