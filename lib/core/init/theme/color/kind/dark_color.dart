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
    scaffoldBackgroundColor = colors.darkGrey;
    tabBarColor = colors.mediumdGreyBold;
    tabbarNormalColor = colors.lighterGrey;
    tabbarSelectedColor = colors.mediumdGreyBold;
    colorScheme = ColorScheme.dark().copyWith(
      onPrimary: colors.mediumdGreyBold,
      onSecondary: colors.darkGrey,
      secondaryVariant: colors.darkerGrey,
      surface: colors.green,
    );
    brightness = Brightness.dark;
  }
}
