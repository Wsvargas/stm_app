import 'package:firebase_data_connect/firebase_data_connect.dart';
import 'package:flutter/foundation.dart';
import '../models/task_model.dart';
import '../dataconnect_generated/generated.dart';
import 'auth_service.dart';

class TaskService extends ChangeNotifier {
  static final TaskService instance = TaskService._();
  TaskService._();

  List<Task> _tasks = [];
  List<Task> get tasks => List.unmodifiable(_tasks);

  static DateTime _fromTs(Timestamp ts) =>
      DateTime.fromMillisecondsSinceEpoch(ts.seconds.toInt() * 1000);

  Future<void> load() async {
    final dbId = AuthService.instance.currentAppUser?.dbId;
    if (dbId == null) return;

    final result = await ExampleConnector.instance
        .listTasksByUser(assignedToId: dbId)
        .execute();

    _tasks = result.data.tasks.map((t) => Task(
      id: t.id,
      title: t.title,
      description: t.description ?? '',
      priority: t.priority,
      subject: t.unit.code,
      estimatedHours: t.estimatedHours ?? 1.0,
      completedHours: t.completedHours ?? 0.0,
      dueDate: _fromTs(t.dueDate),
      status: t.status,
    )).toList();

    notifyListeners();
  }

  Future<void> update(Task t) async {
    await ExampleConnector.instance.updateTaskStatus(
      id: t.id,
      status: t.status,
      completedHours: t.completedHours,
    ).execute();

    final i = _tasks.indexWhere((x) => x.id == t.id);
    if (i != -1) _tasks[i] = t;
    notifyListeners();
  }

  Future<void> delete(String id) async {
    await ExampleConnector.instance.deleteTask(id: id).execute();
    _tasks.removeWhere((x) => x.id == id);
    notifyListeners();
  }

  List<Task> forDate(DateTime day) => _tasks.where((t) {
        if (t.dueDate == null) return false;
        return t.dueDate!.year == day.year &&
            t.dueDate!.month == day.month &&
            t.dueDate!.day == day.day;
      }).toList();
}
