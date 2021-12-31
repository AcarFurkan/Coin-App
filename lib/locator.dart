import 'package:get_it/get_it.dart';

import 'product/repository/cache/coin_cache_manager.dart';

GetIt locator = GetIt.I; // GetIt.I -  GetIt.instance - nin kisaltmasidir

void setupLocator() {
  locator.registerLazySingleton(() => CoinCacheManager("usercache"));
}
