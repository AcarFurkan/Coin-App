import 'product/repository/service/coin_repository.dart';
import 'package:get_it/get_it.dart';

import 'product/repository/cache/coin_cache_manager.dart';
import 'product/viewmodel/service_viewmodel.dart';

GetIt locator = GetIt.I; // GetIt.I -  GetIt.instance - nin kisaltmasidir

void setupLocator() {
  locator.registerLazySingleton(() => CoinCacheManager("usercache"));
  locator.registerLazySingleton(() => ServiceViewModel(CoinListRepository()));
}
