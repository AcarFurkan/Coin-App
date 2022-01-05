import 'package:dio/dio.dart';

import 'ICore_dio.dart';
import 'core_dio.dart';

class NetworkManager {
  static NetworkManager? _instace;
  static NetworkManager get instance {
    _instace ??= NetworkManager._init();
    return _instace!;
  }

  ICoreDio? coreDio;
  NetworkManager._init() {
    final baseOptions =
        BaseOptions(); //baseUrl: dotenv.get(DotEnvEnums.BASE_URL_COIN_GECHO.name)
    coreDio = CoreDio(baseOptions);
  }
}
