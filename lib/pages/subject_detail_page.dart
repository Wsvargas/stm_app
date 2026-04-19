import 'package:flutter/material.dart';
import '../models/unit_model.dart';
import '../services/task_service.dart';
import '../services/groups_service.dart';
import 'group_page.dart';
import 'task_board_page.dart';

class SubjectDetailPage extends StatelessWidget {
  final UnitModel unit;
  const SubjectDetailPage({super.key, required this.unit});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(unit.code),
        backgroundColor: const Color(0xFF000000),
        elevation: 0,
      ),
      body: ListenableBuilder(
        listenable: TaskService.instance,
        builder: (context, _) {
          final tasks = TaskService.instance.tasks
              .where((t) => t.subject == unit.code)
              .toList();
          final totalH =
              tasks.fold<double>(0, (s, t) => s + t.estimatedHours);
          final doneH =
              tasks.fold<double>(0, (s, t) => s + t.completedHours);
          final pct =
              totalH > 0 ? (doneH / totalH).clamp(0.0, 1.0) : 0.0;
          final group = GroupsService.instance.forUnit(unit.id);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Unit header ───────────────────────────
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1A1A),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                        color: const Color(0xFF4A7BFF).withValues(alpha: 0.3)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(unit.name,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Row(children: [
                        const Icon(Icons.person_outline,
                            size: 14, color: Colors.white38),
                        const SizedBox(width: 4),
                        Text(unit.lecturerName,
                            style: const TextStyle(
                                color: Colors.white54, fontSize: 13)),
                      ]),
                      if (unit.description.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Text(unit.description,
                            style: const TextStyle(
                                color: Colors.white38, fontSize: 12)),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // ── Progress ──────────────────────────────
                _SectionHeader(title: 'Progress', icon: Icons.trending_up),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1A1A),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _ProgressStat(
                              label: 'Total Hours',
                              value: '${totalH.toStringAsFixed(1)}h',
                              color: Colors.white70),
                          _ProgressStat(
                              label: 'Completed',
                              value: '${doneH.toStringAsFixed(1)}h',
                              color: const Color(0xFF4CAF50)),
                          _ProgressStat(
                              label: 'Progress',
                              value: '${(pct * 100).toInt()}%',
                              color: const Color(0xFF4A7BFF)),
                        ],
                      ),
                      const SizedBox(height: 14),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: LinearProgressIndicator(
                          value: pct,
                          backgroundColor: Colors.white12,
                          valueColor: const AlwaysStoppedAnimation(
                              Color(0xFF4A7BFF)),
                          minHeight: 10,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // ── Tasks ─────────────────────────────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _SectionHeader(
                        title: 'Tasks (${tasks.length})',
                        icon: Icons.task_outlined),
                    TextButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) =>
                                TaskBoardPage(unit: unit)),
                      ),
                      child: const Text('Board view',
                          style: TextStyle(
                              color: Color(0xFF4A7BFF), fontSize: 12)),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                if (tasks.isEmpty)
                  const _EmptyHint(text: 'No tasks assigned yet.')
                else
                  ...tasks.take(4).map((t) => _TaskRow(task: t)),
                if (tasks.length > 4)
                  TextButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => TaskBoardPage(unit: unit)),
                    ),
                    child: Text(
                        'See all ${tasks.length} tasks →',
                        style: const TextStyle(
                            color: Color(0xFF4A7BFF), fontSize: 12)),
                  ),
                const SizedBox(height: 20),

                // ── Group ─────────────────────────────────
                _SectionHeader(
                    title: 'My Group', icon: Icons.group_outlined),
                const SizedBox(height: 8),
                if (group == null)
                  const _EmptyHint(text: 'No group assigned yet.')
                else
                  GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => GroupPage(group: group)),
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A1A1A),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(children: [
                        const Icon(Icons.group,
                            color: Color(0xFF4A7BFF), size: 28),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(group.name,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600)),
                              Text(
                                  '${group.members.length} members',
                                  style: const TextStyle(
                                      color: Colors.white38,
                                      fontSize: 12)),
                            ],
                          ),
                        ),
                        const Icon(Icons.chevron_right,
                            color: Colors.white38),
                      ]),
                    ),
                  ),
                const SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
    );
  }
}

// ── Helper widgets ────────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;
  const _SectionHeader({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) => Row(children: [
        Icon(icon, size: 16, color: const Color(0xFF4A7BFF)),
        const SizedBox(width: 6),
        Text(title,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold)),
      ]);
}

class _ProgressStat extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _ProgressStat(
      {required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) => Column(children: [
        Text(value,
            style: TextStyle(
                color: color,
                fontSize: 18,
                fontWeight: FontWeight.bold)),
        const SizedBox(height: 2),
        Text(label,
            style:
                const TextStyle(color: Colors.white38, fontSize: 11)),
      ]);
}

class _TaskRow extends StatelessWidget {
  final dynamic task;
  const _TaskRow({required this.task});

  static const _statusColors = {
    'To Do': Colors.white38,
    'In Progress': Color(0xFFFFAA00),
    'Done': Color(0xFF4CAF50),
  };
  static const _priorityColors = {
    'High': Color(0xFFFF4444),
    'Medium': Color(0xFFFFAA00),
    'Low': Color(0xFF4A7BFF),
  };

  @override
  Widget build(BuildContext context) {
    final sc = _statusColors[task.status] ?? Colors.white38;
    final pc =
        _priorityColors[task.priority] ?? const Color(0xFF4A7BFF);
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF242424),
        borderRadius: BorderRadius.circular(10),
        border: Border(left: BorderSide(color: pc, width: 3)),
      ),
      child: Row(children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(task.title,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      decoration: task.isDone
                          ? TextDecoration.lineThrough
                          : null)),
              const SizedBox(height: 4),
              Row(children: [
                _chip(task.status, sc),
                _chip('${task.estimatedHours.toStringAsFixed(1)}h',
                    Colors.white24),
              ]),
            ],
          ),
        ),
        if (task.dueDate != null)
          Text(
            '${task.dueDate!.day}/${task.dueDate!.month}',
            style:
                const TextStyle(color: Colors.white38, fontSize: 11),
          ),
      ]),
    );
  }

  Widget _chip(String label, Color color) => Container(
        margin: const EdgeInsets.only(right: 6),
        padding:
            const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.18),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(label,
            style: TextStyle(color: color, fontSize: 10)),
      );
}

class _EmptyHint extends StatelessWidget {
  final String text;
  const _EmptyHint({required this.text});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Text(text,
            style:
                const TextStyle(color: Colors.white24, fontSize: 13)),
      );
}
