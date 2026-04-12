import 'package:flutter/material.dart';
import '../services/task_service.dart';
import '../models/task_model.dart';

/// Units/subjects the student can enrol in.
/// When a lecturer adds a task to a unit, enrolled students see it here.
class UnitsPage extends StatefulWidget {
  const UnitsPage({super.key});
  @override
  State<UnitsPage> createState() => _UnitsPageState();
}

class _UnitsPageState extends State<UnitsPage> {
  static const _allUnits = [
    _Unit('ICT305', 'Topics in IT'),
    _Unit('ICT306', 'Network Security'),
    _Unit('ICT307', 'Capstone Project 1'),
    _Unit('ICT308', 'Capstone Project 2'),
    _Unit('ICT309', 'Advanced Cyber Security'),
  ];

  final Set<String> _enrolled = {};

  @override
  void initState() {
    super.initState();
    TaskService.instance.load();
  }

  void _toggleEnrol(String code) =>
      setState(() => _enrolled.contains(code)
          ? _enrolled.remove(code)
          : _enrolled.add(code));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('My Units'),
        backgroundColor: const Color(0xFF000000),
      ),
      body: ListenableBuilder(
        listenable: TaskService.instance,
        builder: (context, _) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const Text(
                'Enrol in your units to see tasks added by your lecturer.',
                style: TextStyle(color: Colors.white54, fontSize: 13),
              ),
              const SizedBox(height: 16),
              ..._allUnits.map((u) {
                final isEnrolled = _enrolled.contains(u.code);
                final unitTasks = TaskService.instance.tasks
                    .where((t) => t.subject == u.code)
                    .toList();

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1A1A),
                    borderRadius: BorderRadius.circular(14),
                    border: isEnrolled
                        ? Border.all(color: const Color(0xFF4A7BFF), width: 1.5)
                        : null,
                  ),
                  child: Column(
                    children: [
                      ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 4),
                        title: Text(u.code,
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                        subtitle: Text(u.name,
                            style:
                                const TextStyle(color: Colors.white54)),
                        trailing: TextButton(
                          onPressed: () => _toggleEnrol(u.code),
                          style: TextButton.styleFrom(
                            backgroundColor: isEnrolled
                                ? Colors.red.withValues(alpha: 0.15)
                                : const Color(0xFF4A7BFF)
                                    .withValues(alpha: 0.15),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                          ),
                          child: Text(
                            isEnrolled ? 'Drop' : 'Enrol',
                            style: TextStyle(
                              color: isEnrolled
                                  ? Colors.red
                                  : const Color(0xFF4A7BFF),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      if (isEnrolled && unitTasks.isNotEmpty) ...[
                        const Divider(color: Colors.white12, height: 1),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Tasks from lecturer',
                                  style: TextStyle(
                                      color: Colors.white38,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600)),
                              const SizedBox(height: 6),
                              ...unitTasks.map((t) => _TaskRow(task: t)),
                            ],
                          ),
                        ),
                      ],
                      if (isEnrolled && unitTasks.isEmpty)
                        const Padding(
                          padding: EdgeInsets.fromLTRB(16, 0, 16, 12),
                          child: Text('No tasks assigned yet.',
                              style: TextStyle(
                                  color: Colors.white24, fontSize: 12)),
                        ),
                    ],
                  ),
                );
              }),
            ],
          );
        },
      ),
    );
  }
}

class _TaskRow extends StatelessWidget {
  final Task task;
  const _TaskRow({required this.task});

  static const _priorityColors = {
    'High': Color(0xFFFF4444),
    'Medium': Color(0xFFFFAA00),
    'Low': Color(0xFF4A7BFF),
  };

  @override
  Widget build(BuildContext context) {
    final color = _priorityColors[task.priority] ?? const Color(0xFF4A7BFF);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(Icons.circle, color: color, size: 8),
          const SizedBox(width: 8),
          Expanded(
            child: Text(task.title,
                style: const TextStyle(color: Colors.white70, fontSize: 13)),
          ),
          if (task.dueDate != null)
            Text(
              '${task.dueDate!.day}/${task.dueDate!.month}',
              style: const TextStyle(color: Colors.white38, fontSize: 11),
            ),
        ],
      ),
    );
  }
}

class _Unit {
  final String code;
  final String name;
  const _Unit(this.code, this.name);
}
