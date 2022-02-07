class AppConstant {
  static AppConstant? _instance;

  static AppConstant get instance {
    _instance ??= AppConstant._init();
    return _instance!;
  }

  AppConstant._init() {
    LANG_ASSET_PATH = 'assets/langs';
    SPLASH_GIF_PATH = 'assets/gif/splash35.gif';
    HELP_IMAGE_PATH = "assets/images/help.png";
    LOGIN_IMAGE_PATH = "assets/svg/login2.svg";
    IMAGE_404 = "assets/images/404.png";
    WELCOME_PAGE = "assets/images/welcome_two.png";
    BTC_ICON = "assets/icon/btcIcon.png";
    PROFILE_IMAGE_PATH = "assets/images/profile_3d_eight.png";
    SEARCH_IMAGE_PATH = "assets/svg/search.svg";
    SVG_404_PATH = "assets/svg/404_svg.svg";
    ADD_IMAGE_PATH = "assets/svg/add.svg";
  }

  late final String LANG_ASSET_PATH;
  late final String SPLASH_GIF_PATH;
  late final String HELP_IMAGE_PATH;
  late final String LOGIN_IMAGE_PATH;
  late final String IMAGE_404;
  late final String WELCOME_PAGE;
  late final String BTC_ICON;
  late final String PROFILE_IMAGE_PATH;
  late final String SEARCH_IMAGE_PATH;
  late final String SVG_404_PATH;
  late final String ADD_IMAGE_PATH;
}
