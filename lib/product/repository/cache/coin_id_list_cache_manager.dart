import 'package:hive/hive.dart';

class CoinIdListCacheManager {
  final String key;
  Box<Map>? _box;

  CoinIdListCacheManager(this.key);

  Future<void> init() async {
    // registerAdapters();
    if (!(_box?.isOpen ?? false)) {
      _box = await Hive.openBox(key);
    }
  }

  Future<void> addItems(Map items) async {
    await _box?.addAll([items]);
  }

  Map? getAllItems() {
    if (_box != null) {
      print(_box?.values.length);
      return _box!.values.toList().isNotEmpty ? _box?.values.toList()[0] : null;
    }
  }

  List? getkeys() {
    return _box?.keys.toList();
  }

  Future<void> clearAll() async {
    await _box?.clear();
  }

  // void registerAdapters() {
  //   if (!Hive.isAdapterRegistered(2)) {
  //     // Hive.registerAdapter(GechoAllIdListAdapter());
  //   }
  // }
}
