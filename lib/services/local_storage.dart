import 'package:hive/hive.dart';
import '../models/task_model.dart';

abstract class LocalStorage {
  Future<void> addTask({required Task task});
  Future<Task?> getTask({required String id});
  Future<List<Task>> getAllTasks();
  Future<void> deleteTask({required Task task});
  Future<void> updateTask({required Task task});
}

class HiveLocal extends LocalStorage {
  late Box<Task> allTasks;

  HiveLocal() {
    allTasks = Hive.box<Task>("tasks");
  }
  @override
  Future<void> addTask({required Task task}) async {
    allTasks.put(task.id, task);
  }

  @override
  Future<void> deleteTask({required Task task}) async {
    await task.delete();
  }

  @override
  Future<List<Task>> getAllTasks() async {
    List<Task> tasks = allTasks.values.toList();
    if (tasks.isNotEmpty) {
      tasks.sort(
        (Task a, Task b) {
          return a.date.compareTo(b.date);
        },
      );
    }
    return tasks;
  }

  @override
  Future<Task?> getTask({required String id}) async {
    if (allTasks.containsKey(id)) {
      return allTasks.get(id);
    } else {
      return null;
    }
  }

  @override
  Future<void> updateTask({required Task task}) async {
    task.save();
  }
}
