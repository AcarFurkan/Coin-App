import 'package:hive/hive.dart';

class AppCacheManager {
  final String key;
  Box<String>? _box;

  AppCacheManager(this.key);

  Future<void> init() async {
    registerAdapters();
    if (!(_box?.isOpen ?? false)) {
      _box = await Hive.openBox(key);
    }
    /*if (_box == null) {
      _box = await Hive.openBox(key);
    }*/
  }

  Future<void> addItems(List<String> items) async {
    await _box?.addAll(items);
  }

  //Future<void> putItems(List<String> items) async {
  //  await _box?.putAll(Map.fromEntries(items.map((e) => MapEntry(e.name, e))));
  //}

  String? getItem(String key) {
    return _box?.get(key);
  }

  Future<void> putItem(String key, String item) async {
    await _box?.put(key, item);
  }

  Future<void> putBoolItem(String key, bool item) async {
    await _box?.put(key, item.toString());
  }

  getBoolValue(String key) {
    return (_box?.get(key) ?? false).toString();
  }

  Future<void> removeItem(String key) async {
    await _box?.delete(key);
  }

  List<String>? getValues() {
    return _box?.values.toList();
  }

  List? getkeys() {
    return _box?.keys.toList();
  }

  Future<void> clearAll() async {
    await _box?.clear();
  }

  void registerAdapters() {}
}
