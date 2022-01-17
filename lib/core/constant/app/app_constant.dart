class AppConstant {
  static AppConstant? _instance;

  static AppConstant get instance {
    _instance ??= AppConstant._init();
    return _instance!;
  }

  AppConstant._init() {
    LANG_ASSET_PATH = 'assets/langs';
  }

  late final String LANG_ASSET_PATH;
}
