import 'package:flutter/material.dart';
import '../models/task_model.dart';
import '../services/task_service.dart';
import 'tasks_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});
  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  void initState() {
    super.initState();
    TaskService.instance.load();
  }

  String _daysLeft(DateTime due) {
    final diff = due.difference(DateTime.now()).inDays;
    if (diff < 0) return 'Overdue';
    if (diff == 0) return 'Due today';
    if (diff == 1) return 'Due tomorrow';
    return 'Due in $diff days';
  }

  Color _dueColor(DateTime due) {
    final diff = due.difference(DateTime.now()).inDays;
    if (diff < 0) return Colors.red;
    if (diff <= 2) return const Color(0xFFFFAA00);
    return Colors.white70;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Dashboard'),
        backgroundColor: const Color(0xFF000000),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Colors.white),
            tooltip: 'Notifications',
            onPressed: () => showModalBottomSheet(
              context: context,
              backgroundColor: const Color(0xFF1A1A1A),
              shape: const RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(20))),
              builder: (_) => const Padding(
                padding: EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Notifications',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold)),
                    SizedBox(height: 16),
                    Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Text('No new notifications.',
                            style:
                                TextStyle(color: Colors.white38, fontSize: 14)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      body: ListenableBuilder(
        listenable: TaskService.instance,
        builder: (context, _) {
          final tasks = TaskService.instance.tasks;
          final done = tasks.where((t) => t.isDone).length;
          final totalHours = tasks.fold<double>(
              0, (sum, t) => sum + (t.isDone ? t.estimatedHours : 0));
          final upcoming = tasks
              .where((t) => !t.isDone && t.dueDate != null)
              .toList()
            ..sort((a, b) => a.dueDate!.compareTo(b.dueDate!));

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Stats ─────────────────────────────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    StatCard(
                        label: 'Tasks Done',
                        value: '$done/${tasks.length}'),
                    StatCard(
                        label: 'Study Hours',
                        value: '${totalHours.toStringAsFixed(1)}h'),
                    StatCard(
                        label: 'Pending',
                        value: '${tasks.length - done}'),
                  ],
                ),
                const SizedBox(height: 20),

                // ── Quote ─────────────────────────────────
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1A1A),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Text(
                    '"The beautiful thing about learning is that no one can take it away from you."',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // ── Upcoming Deadlines ────────────────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Upcoming Deadlines',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold)),
                    TextButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const TasksPage()),
                      ),
                      child: const Text('See all',
                          style: TextStyle(color: Color(0xFF4A7BFF))),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                if (upcoming.isEmpty)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Text('No upcoming deadlines.',
                          style: TextStyle(color: Colors.white38)),
                    ),
                  )
                else
                  ...upcoming.take(5).map((t) => _DeadlineCard(
                        task: t,
                        daysLeft: _daysLeft(t.dueDate!),
                        dueColor: _dueColor(t.dueDate!),
                      )),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _DeadlineCard extends StatelessWidget {
  final Task task;
  final String daysLeft;
  final Color dueColor;
  const _DeadlineCard(
      {required this.task,
      required this.daysLeft,
      required this.dueColor});

  static const _priorityColors = {
    'High': Color(0xFFFF4444),
    'Medium': Color(0xFFFFAA00),
    'Low': Color(0xFF4A7BFF),
  };

  @override
  Widget build(BuildContext context) {
    final pc = _priorityColors[task.priority] ?? const Color(0xFF4A7BFF);
    return GestureDetector(
      onTap: () => _showDetail(context),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(12),
          border: Border(left: BorderSide(color: pc, width: 3)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(task.title,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Row(children: [
                    Icon(Icons.access_time, size: 12, color: dueColor),
                    const SizedBox(width: 4),
                    Text(daysLeft,
                        style:
                            TextStyle(color: dueColor, fontSize: 12)),
                    if (task.subject.isNotEmpty) ...[
                      const SizedBox(width: 8),
                      Text('· ${task.subject}',
                          style: const TextStyle(
                              color: Colors.white38, fontSize: 12)),
                    ],
                    const SizedBox(width: 8),
                    Icon(Icons.hourglass_empty,
                        size: 12, color: Colors.white38),
                    const SizedBox(width: 2),
                    Text('${task.estimatedHours.toStringAsFixed(1)}h',
                        style: const TextStyle(
                            color: Colors.white38, fontSize: 12)),
                  ]),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.white38),
          ],
        ),
      ),
    );
  }

  void _showDetail(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1A1A1A),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Expanded(
                child: Text(task.title,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold)),
              ),
              _chip(task.priority,
                  _priorityColors[task.priority] ?? const Color(0xFF4A7BFF)),
            ]),
            const SizedBox(height: 12),
            if (task.description.isNotEmpty) ...[
              Text(task.description,
                  style: const TextStyle(
                      color: Colors.white70, fontSize: 14)),
              const SizedBox(height: 12),
            ],
            _row(Icons.calendar_today, 'Deadline',
                '${task.dueDate!.day}/${task.dueDate!.month}/${task.dueDate!.year}'),
            _row(Icons.hourglass_empty, 'Est. time',
                '${task.estimatedHours.toStringAsFixed(1)} hours'),
            if (task.subject.isNotEmpty)
              _row(Icons.book_outlined, 'Subject', task.subject),
            _row(Icons.category_outlined, 'Category', task.category),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _row(IconData icon, String label, String value) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(children: [
          Icon(icon, size: 16, color: const Color(0xFF4A7BFF)),
          const SizedBox(width: 8),
          Text('$label: ',
              style: const TextStyle(color: Colors.white54, fontSize: 13)),
          Text(value,
              style: const TextStyle(color: Colors.white, fontSize: 13)),
        ]),
      );

  Widget _chip(String label, Color color) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(label,
            style: TextStyle(
                color: color,
                fontSize: 11,
                fontWeight: FontWeight.w600)),
      );
}

// ── Reusable widgets ──────────────────────────────────────────────────────────

class StatCard extends StatelessWidget {
  final String label;
  final String value;
  const StatCard({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
      ],
    );
  }
}

class TaskCard extends StatelessWidget {
  final String title;
  final String due;
  final Color color;
  const TaskCard(
      {super.key,
      required this.title,
      required this.due,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(due, style: const TextStyle(color: Colors.white70)),
        ],
      ),
    );
  }
}
