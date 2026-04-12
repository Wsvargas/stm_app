import '../models/task_model.dart';

/// Pure in-memory storage — no SQLite, works on all platforms.
class DatabaseService {
  static final DatabaseService instance = DatabaseService._();
  DatabaseService._();

  final List<Task> _tasks = [];

  Future<List<Task>> getAll() async => List.from(_tasks);

  Future<void> insert(Task t) async {
    _tasks.removeWhere((e) => e.id == t.id);
    _tasks.add(t);
  }

  Future<void> update(Task t) async {
    final i = _tasks.indexWhere((e) => e.id == t.id);
    if (i >= 0) _tasks[i] = t;
  }

  Future<void> delete(String id) async {
    _tasks.removeWhere((e) => e.id == id);
  }
}
