import 'package:flutter/material.dart';
import '../models/task_model.dart';
import '../services/task_service.dart';
import 'add_event_page.dart';

class TasksPage extends StatefulWidget {
  const TasksPage({super.key});
  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  String _filter = 'All'; // All, High, Medium, Low

  static const _priorityColors = {
    'High': Color(0xFFFF4444),
    'Medium': Color(0xFFFFAA00),
    'Low': Color(0xFF4A7BFF),
  };

  @override
  void initState() {
    super.initState();
    TaskService.instance.load();
  }

  Future<void> _openAdd() async {
    final result = await Navigator.push<Map<String, String>>(
      context,
      MaterialPageRoute(
          builder: (_) => AddEventPage(initialDate: DateTime.now())),
    );
    if (result == null || result['title']!.isEmpty) return;
    final task = Task(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: result['title']!,
      description: result['description'] ?? '',
      priority: result['priority'] ?? 'Medium',
      category: result['category'] ?? 'Task',
      subject: result['subject'] ?? '',
      time: result['time'] ?? '',
      dueDate: result['date'] != null ? DateTime.tryParse(result['date']!) : null,
      estimatedHours: double.tryParse(result['estimatedHours'] ?? '1.0') ?? 1.0,
    );
    await TaskService.instance.add(task);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Tasks'),
        backgroundColor: const Color(0xFF000000),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF4A7BFF),
        onPressed: _openAdd,
        child: const Icon(Icons.add),
      ),
      body: ListenableBuilder(
        listenable: TaskService.instance,
        builder: (context, _) {
          final allTasks = TaskService.instance.tasks;
          final filtered = _filter == 'All'
              ? allTasks
              : allTasks.where((t) => t.priority == _filter).toList();

          final done = filtered.where((t) => t.isDone).length;

          return Column(
            children: [
              // ── Stats bar ──────────────────────────────
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1A1A),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _stat('Total', '${filtered.length}', Colors.white70),
                    _stat('Done', '$done', const Color(0xFF4CAF50)),
                    _stat('Pending', '${filtered.length - done}',
                        const Color(0xFFFFAA00)),
                  ],
                ),
              ),

              // ── Priority filter ────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: ['All', 'High', 'Medium', 'Low'].map((f) {
                    final selected = _filter == f;
                    final color = f == 'All'
                        ? Colors.white
                        : _priorityColors[f]!;
                    return Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _filter = f),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 160),
                          margin: EdgeInsets.only(
                              right: f == 'Low' ? 0 : 8),
                          padding:
                              const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            color: selected
                                ? color.withValues(alpha: 0.15)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: selected
                                    ? color
                                    : Colors.white24),
                          ),
                          child: Text(f,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: selected
                                      ? color
                                      : Colors.white38,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600)),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 12),

              // ── Task list ─────────────────────────────
              Expanded(
                child: filtered.isEmpty
                    ? const Center(
                        child: Text('No tasks yet — tap + to add one.',
                            style: TextStyle(
                                color: Colors.white38, fontSize: 14)))
                    : ListView.builder(
                        padding:
                            const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: filtered.length,
                        itemBuilder: (_, i) {
                          final t = filtered[i];
                          final pc = _priorityColors[t.priority] ??
                              const Color(0xFF4A7BFF);
                          return Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1A1A1A),
                              borderRadius: BorderRadius.circular(12),
                              border: Border(
                                  left: BorderSide(
                                      color: pc, width: 3)),
                            ),
                            child: Row(
                              children: [
                                Checkbox(
                                  value: t.isDone,
                                  onChanged: (_) async {
                                    t.isDone = !t.isDone;
                                    await TaskService.instance.update(t);
                                  },
                                  activeColor: const Color(0xFF4A7BFF),
                                  side: const BorderSide(
                                      color: Colors.white38),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(t.title,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                            decoration: t.isDone
                                                ? TextDecoration
                                                    .lineThrough
                                                : null,
                                          )),
                                      if (t.description.isNotEmpty)
                                        Text(t.description,
                                            style: const TextStyle(
                                                color: Colors.white54,
                                                fontSize: 12)),
                                      const SizedBox(height: 4),
                                      Row(children: [
                                        _chip(t.priority, pc),
                                        if (t.subject.isNotEmpty)
                                          _chip(t.subject, Colors.white38),
                                        _chip('${t.estimatedHours.toStringAsFixed(1)}h', const Color(0xFF4A7BFF)),
                                        if (t.dueDate != null)
                                          _chip(
                                            '${t.dueDate!.day}/${t.dueDate!.month}/${t.dueDate!.year}',
                                            Colors.white24,
                                          ),
                                      ]),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete_outline,
                                      color: Colors.red, size: 20),
                                  onPressed: () =>
                                      TaskService.instance.delete(t.id),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _stat(String label, String val, Color color) => Column(
        children: [
          Text(val,
              style: TextStyle(
                  color: color,
                  fontSize: 22,
                  fontWeight: FontWeight.bold)),
          Text(label,
              style:
                  const TextStyle(color: Colors.white54, fontSize: 12)),
        ],
      );

  Widget _chip(String label, Color color) => Container(
        margin: const EdgeInsets.only(right: 4),
        padding:
            const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(label,
            style: TextStyle(color: color, fontSize: 10)),
      );
}
