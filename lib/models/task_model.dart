import 'package:hive_flutter/adapters.dart';
import 'package:uuid/uuid.dart';

part 'task_model.g.dart';

@HiveType(typeId: 0)
class Task extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  String name;
  @HiveField(2)
  final DateTime date;
  @HiveField(3)
  bool isCompleted;

  factory Task.create(String name, DateTime date) {
    return Task(
        id: const Uuid().v1(), name: name, date: date, isCompleted: false);
  }

  Task(
      {required this.id,
      required this.name,
      required this.date,
      required this.isCompleted});
}
