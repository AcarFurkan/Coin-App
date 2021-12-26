import 'package:coin_with_architecture/core/enums/dotenv_enums.dart';
import 'package:coin_with_architecture/core/init/network/ICore_dio.dart';
import 'package:coin_with_architecture/core/init/network/core_dio.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

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
