import 'package:hive/hive.dart';

@HiveType()
class CoinIdList extends HiveObject {
  @HiveField(0)
  HiveList ids;

  CoinIdList(this.ids);
}

//class PersonAdapter extends TypeAdapter<CoinIdList> {
//  @override
//  final typeId = 0;
//
//  @override
//  CoinIdList read(BinaryReader reader) {
//    return CoinIdList(reader.read())..ids = reader.read();
//  }
//
//  @override
//  void write(BinaryWriter writer, CoinIdList obj) {
//    writer.write(obj.ids);
//  }
//}
