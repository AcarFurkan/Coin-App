import 'package:hive/hive.dart';

part 'audio_model.g.dart';

@HiveType(typeId: 2)
class AudioModel {
  @HiveField(0)
  final String name;
  @HiveField(1)
  final String path;

  AudioModel(this.name, this.path);
}
