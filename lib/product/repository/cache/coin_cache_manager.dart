import '../../model/coin/my_coin_model.dart';
import 'package:hive/hive.dart';

import '../../../features/settings/subpage/audio_settings/model/audio_model.dart';

class CoinCacheManager {
  final String key;
  Box<MainCurrencyModel>? _box;

  CoinCacheManager(this.key);

  Future<void> init() async {
    registerAdapters();
    if (!(_box?.isOpen ?? false)) {
      _box = await Hive.openBox(key);
    }
    /*if (_box == null) {
      _box = await Hive.openBox(key);
    }*/
  }

  Future<void> addItems(List<MainCurrencyModel> items) async {
    await _box?.addAll(items);
  }

  Future<void> putItems(List<MainCurrencyModel> items) async {
    await _box?.putAll(Map.fromEntries(items.map((e) => MapEntry(e.name, e))));
  }

  MainCurrencyModel? getItem(String key) {
    return _box?.get(key);
  }

  Future<void> putItem(String key, MainCurrencyModel item) async {
    await _box?.put(key, item);
  }

  Future<void> removeItem(String key) async {
    await _box?.delete(key);
  }

  List<MainCurrencyModel>? getValues() {
    return _box?.values.toList();
  }

  List? getkeys() {
    return _box?.keys.toList();
  }

  Future<void> clearAll() async {
    await _box?.clear();
  }

  void registerAdapters() {
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(MainCurrencyModelAdapter());
      Hive.registerAdapter(AudioModelAdapter());
    }
  }
}
