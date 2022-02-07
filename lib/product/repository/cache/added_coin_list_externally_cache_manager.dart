import 'package:hive/hive.dart';

import '../../response_models/gecho/gecho_id_list_model.dart';

class AddedCoinListExternally {
  final String key;
  Box<String>? _box;

  AddedCoinListExternally(this.key);

  Future<void> init() async {
    registerAdapters();
    if (!(_box?.isOpen ?? false)) {
      _box = await Hive.openBox(key);
    }
  }

  Future<void> addItems(List<String> items) async {
    await _box?.addAll(items);
  }

  List<String>? getAllItems() {
    return _box?.values.toList();
  }

  Future<void> putItems(List<String> items) async {
    await _box?.putAll(Map.fromEntries(items.map((e) => MapEntry(e, e))));
  }

  String? getItem(String key) {
    return _box?.get(key);
  }

  Future<void> putItem(String key, String item) async {
    await _box?.put(key, item);
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

  void registerAdapters() {
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(GechoAllIdListAdapter());
    }
  }
}
