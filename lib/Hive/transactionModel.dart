// ignore_for_file: file_names

import 'package:hive_flutter/adapters.dart';
part 'transactionModel.g.dart';

@HiveType(typeId: 1)
class Transactionmodel {
  @HiveField(0)
  late final DateTime time;
  @HiveField(1)
  late final bool isIncome;
  @HiveField(2)
  late final String categorie;
  @HiveField(3)
  late final double amount;
  @HiveField(5)
  String? notes;

  Transactionmodel(
      {required this.time,
      required this.isIncome,
      required this.categorie,
      required this.amount,
      this.notes});
}
