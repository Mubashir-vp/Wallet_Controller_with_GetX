import 'package:hive_flutter/adapters.dart';
part 'model.g.dart';

@HiveType(typeId: 0)
class Model {
  @HiveField(0)
  final bool field;
  @HiveField(1)
  final String cat;
  @HiveField(2)
  Model({required this.cat, required this.field});
}
