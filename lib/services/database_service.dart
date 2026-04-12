import 'package:flutter/foundation.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';
import '../models/task_model.dart';

class DatabaseService {
  static final DatabaseService instance = DatabaseService._();
  DatabaseService._();

  static Database? _db;

  Future<Database> get database async {
    _db ??= await _init();
    return _db!;
  }

  Future<Database> _init() async {
    // Desktop support (Windows / Linux / macOS)
    if (!kIsWeb) {
      try {
        if (defaultTargetPlatform == TargetPlatform.windows ||
            defaultTargetPlatform == TargetPlatform.linux ||
            defaultTargetPlatform == TargetPlatform.macOS) {
          sqfliteFfiInit();
          databaseFactory = databaseFactoryFfi;
        }
      } catch (_) {}
    }

    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'stm_tasks.db');

    return openDatabase(
      path,
      version: 2,
      onCreate: (db, _) async {
        await db.execute('''
          CREATE TABLE tasks (
            id             TEXT PRIMARY KEY,
            title          TEXT NOT NULL,
            description    TEXT,
            priority       TEXT,
            category       TEXT,
            subject        TEXT,
            time           TEXT,
            estimatedHours REAL DEFAULT 1.0,
            dueDate        TEXT,
            isDone         INTEGER DEFAULT 0
          )
        ''');
      },
      onUpgrade: (db, oldV, newV) async {
        if (oldV < 2) {
          await db.execute(
              'ALTER TABLE tasks ADD COLUMN estimatedHours REAL DEFAULT 1.0');
        }
      },
    );
  }

  Future<List<Task>> getAll() async {
    final db = await database;
    final rows = await db.query('tasks', orderBy: 'dueDate ASC, priority ASC');
    return rows.map(Task.fromMap).toList();
  }

  Future<void> insert(Task t) async {
    final db = await database;
    await db.insert('tasks', t.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> update(Task t) async {
    final db = await database;
    await db.update('tasks', t.toMap(), where: 'id = ?', whereArgs: [t.id]);
  }

  Future<void> delete(String id) async {
    final db = await database;
    await db.delete('tasks', where: 'id = ?', whereArgs: [id]);
  }
}
