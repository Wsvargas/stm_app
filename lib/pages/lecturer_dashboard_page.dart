import 'package:flutter/material.dart';
import '../services/task_service.dart';
import '../services/auth_service.dart';
import 'login_page.dart';

class LecturerDashboardPage extends StatelessWidget {
  const LecturerDashboardPage({super.key});

  static const _units = [
    _UnitData(code: 'ICT308', name: 'Capstone Project 2', students: 24),
    _UnitData(code: 'ICT307', name: 'Capstone Project 1', students: 20),
    _UnitData(code: 'ICT305', name: 'Topics in IT', students: 18),
  ];

  static const _statusColors = {
    'To Do': Color(0xFF888888),
    'In Progress': Color(0xFFFFAA00),
    'Done': Color(0xFF4CAF50),
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Lecturer Dashboard'),
        backgroundColor: const Color(0xFF000000),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white54),
            onPressed: () async {
              await AuthService.instance.signOut();
              if (context.mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginPage()),
                  (_) => false,
                );
              }
            },
          ),
        ],
      ),
      body: ListenableBuilder(
        listenable: TaskService.instance,
        builder: (context, _) {
          final allTasks = TaskService.instance.tasks;
          final toDo =
              allTasks.where((t) => t.status == 'To Do').length;
          final inProg =
              allTasks.where((t) => t.status == 'In Progress').length;
          final done =
              allTasks.where((t) => t.status == 'Done').length;
          final totalH =
              allTasks.fold<double>(0, (s, t) => s + t.estimatedHours);
          final doneH =
              allTasks.fold<double>(0, (s, t) => s + t.completedHours);
          final pct =
              totalH > 0 ? (doneH / totalH).clamp(0.0, 1.0) : 0.0;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Welcome ───────────────────────────────
                const Text('Overview',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),

                // ── Top stats ─────────────────────────────
                Row(children: [
                  _StatCard(
                      label: 'Units',
                      value: '${_units.length}',
                      icon: Icons.school_outlined,
                      color: const Color(0xFF4A7BFF)),
                  const SizedBox(width: 10),
                  _StatCard(
                      label: 'Students',
                      value: '${_units.fold(0, (s, u) => s + u.students)}',
                      icon: Icons.people_outline,
                      color: const Color(0xFF4CAF50)),
                  const SizedBox(width: 10),
                  _StatCard(
                      label: 'Tasks',
                      value: '${allTasks.length}',
                      icon: Icons.task_outlined,
                      color: const Color(0xFFFFAA00)),
                ]),
                const SizedBox(height: 20),

                // ── Overall progress ─────────────────────
                const Text('Overall Progress',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1A1A),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(children: [
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                      children: [
                        _progStat('Total Hours',
                            '${totalH.toStringAsFixed(1)}h',
                            Colors.white54),
                        _progStat('Completed',
                            '${doneH.toStringAsFixed(1)}h',
                            const Color(0xFF4CAF50)),
                        _progStat('Progress',
                            '${(pct * 100).toInt()}%',
                            const Color(0xFF4A7BFF)),
                      ],
                    ),
                    const SizedBox(height: 12),
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
                  ]),
                ),
                const SizedBox(height: 20),

                // ── Task status ───────────────────────────
                const Text('Tasks by Status',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Row(children: [
                  _statusPill('To Do', toDo,
                      const Color(0xFF888888)),
                  const SizedBox(width: 8),
                  _statusPill('In Progress', inProg,
                      const Color(0xFFFFAA00)),
                  const SizedBox(width: 8),
                  _statusPill('Done', done,
                      const Color(0xFF4CAF50)),
                ]),
                const SizedBox(height: 20),

                // ── Units ─────────────────────────────────
                const Text('My Units',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                ..._units.map((u) {
                  final unitTasks = allTasks
                      .where((t) => t.subject == u.code)
                      .toList();
                  final uTotalH = unitTasks.fold<double>(
                      0, (s, t) => s + t.estimatedHours);
                  final uDoneH = unitTasks.fold<double>(
                      0, (s, t) => s + t.completedHours);
                  final uPct = uTotalH > 0
                      ? (uDoneH / uTotalH).clamp(0.0, 1.0)
                      : 0.0;
                  final byStatus = {
                    'To Do': unitTasks
                        .where((t) => t.status == 'To Do')
                        .length,
                    'In Progress': unitTasks
                        .where((t) => t.status == 'In Progress')
                        .length,
                    'Done': unitTasks
                        .where((t) => t.status == 'Done')
                        .length,
                  };

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A1A1A),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Text(u.code,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight:
                                            FontWeight.bold)),
                                Text(u.name,
                                    style: const TextStyle(
                                        color: Colors.white54,
                                        fontSize: 12)),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.end,
                            children: [
                              Text('${(uPct * 100).toInt()}%',
                                  style: const TextStyle(
                                      color: Color(0xFF4A7BFF),
                                      fontSize: 18,
                                      fontWeight:
                                          FontWeight.bold)),
                              Text('${u.students} students',
                                  style: const TextStyle(
                                      color: Colors.white38,
                                      fontSize: 11)),
                            ],
                          ),
                        ]),
                        const SizedBox(height: 10),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: uPct,
                            backgroundColor: Colors.white12,
                            valueColor:
                                const AlwaysStoppedAnimation(
                                    Color(0xFF4A7BFF)),
                            minHeight: 6,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(children: byStatus.entries.map((e) {
                          final c = _statusColors[e.key] ??
                              Colors.white38;
                          return Expanded(
                            child: Row(children: [
                              Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                      color: c,
                                      shape: BoxShape.circle)),
                              const SizedBox(width: 4),
                              Text('${e.value} ${e.key}',
                                  style: TextStyle(
                                      color: c, fontSize: 10)),
                            ]),
                          );
                        }).toList()),
                      ],
                    ),
                  );
                }),
              ],
            ),
          );
        },
      ),
    );
  }
}

// ── Helper widgets ────────────────────────────────────────────────────────────

class _UnitData {
  final String code;
  final String name;
  final int students;
  const _UnitData(
      {required this.code,
      required this.name,
      required this.students});
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  const _StatCard(
      {required this.label,
      required this.value,
      required this.icon,
      required this.color});

  @override
  Widget build(BuildContext context) => Expanded(
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A1A),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 6),
            Text(value,
                style: TextStyle(
                    color: color,
                    fontSize: 20,
                    fontWeight: FontWeight.bold)),
            Text(label,
                style: const TextStyle(
                    color: Colors.white38, fontSize: 11)),
          ]),
        ),
      );
}

Widget _progStat(String label, String val, Color color) => Column(
      children: [
        Text(val,
            style: TextStyle(
                color: color,
                fontSize: 16,
                fontWeight: FontWeight.bold)),
        Text(label,
            style:
                const TextStyle(color: Colors.white38, fontSize: 10)),
      ],
    );

Widget _statusPill(String label, int count, Color color) => Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Column(children: [
          Text('$count',
              style: TextStyle(
                  color: color,
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),
          Text(label,
              style:
                  const TextStyle(color: Colors.white38, fontSize: 10)),
        ]),
      ),
    );
