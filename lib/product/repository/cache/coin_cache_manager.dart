import '../../../features/settings/audio_settings/model/audio_model.dart';
import 'package:hive/hive.dart';

import '../../model/my_coin_model.dart';

class CoinCacheManager {
  final String key;
  Box<MyCoin>? _box;

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

  Future<void> addItems(List<MyCoin> items) async {
    await _box?.addAll(items);
  }

  Future<void> putItems(List<MyCoin> items) async {
    await _box?.putAll(Map.fromEntries(items.map((e) => MapEntry(e.name, e))));
  }

  MyCoin? getItem(String key) {
    return _box?.get(key);
  }

  Future<void> putItem(String key, MyCoin item) async {
    await _box?.put(key, item);
  }

  Future<void> removeItem(String key) async {
    await _box?.delete(key);
  }

  List<MyCoin>? getValues() {
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
      Hive.registerAdapter(MyCoinAdapter());
      Hive.registerAdapter(AudioModelAdapter());
    }
  }
}
