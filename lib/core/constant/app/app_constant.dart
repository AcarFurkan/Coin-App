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
  }

  late final String LANG_ASSET_PATH;
  late final String SPLASH_GIF_PATH;
  late final String HELP_IMAGE_PATH;
}
