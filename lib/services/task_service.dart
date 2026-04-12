import 'package:flutter/foundation.dart';
import '../models/task_model.dart';
import 'database_service.dart';

class TaskService extends ChangeNotifier {
  static final TaskService instance = TaskService._();
  TaskService._();

  List<Task> _tasks = [];
  List<Task> get tasks => List.unmodifiable(_tasks);

  Future<void> load() async {
    _tasks = await DatabaseService.instance.getAll();
    notifyListeners();
  }

  Future<void> add(Task t) async {
    await DatabaseService.instance.insert(t);
    _tasks.add(t);
    notifyListeners();
  }

  Future<void> update(Task t) async {
    await DatabaseService.instance.update(t);
    final i = _tasks.indexWhere((x) => x.id == t.id);
    if (i != -1) _tasks[i] = t;
    notifyListeners();
  }

  Future<void> delete(String id) async {
    await DatabaseService.instance.delete(id);
    _tasks.removeWhere((x) => x.id == id);
    notifyListeners();
  }

  List<Task> forDate(DateTime day) {
    return _tasks.where((t) {
      if (t.dueDate == null) return false;
      return t.dueDate!.year == day.year &&
          t.dueDate!.month == day.month &&
          t.dueDate!.day == day.day;
    }).toList();
  }
}
