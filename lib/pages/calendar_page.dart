import 'package:flutter/material.dart';
import '../models/task_model.dart';
import '../services/task_service.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});
  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  late DateTime _focusedMonth;
  DateTime? _selectedDay;

  static const _monthNames = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
  ];

  static const _priorityColors = {
    'High': Color(0xFFFF4444),
    'Medium': Color(0xFFFFAA00),
    'Low': Color(0xFF4A7BFF),
  };

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _focusedMonth = DateTime(now.year, now.month);
    _selectedDay = DateTime(now.year, now.month, now.day);
    TaskService.instance.load();
  }

  void _previousMonth() => setState(() =>
      _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month - 1));

  void _nextMonth() => setState(() =>
      _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month + 1));

  void _openAddEvent(DateTime day) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Tasks are assigned by your lecturer.')),
    );
  }

  Widget _buildCalendarGrid() {
    final firstDay = DateTime(_focusedMonth.year, _focusedMonth.month, 1);
    final lastDay = DateTime(_focusedMonth.year, _focusedMonth.month + 1, 0);
    final today = DateTime.now();
    final startOffset = firstDay.weekday - 1;
    final rows = ((startOffset + lastDay.day) / 7).ceil();

    return Column(
      children: [
        Row(
          children: ['M', 'T', 'W', 'T', 'F', 'S', 'S']
              .map((d) => Expanded(
                    child: Center(
                      child: Text(d,
                          style: const TextStyle(
                              color: Colors.white54,
                              fontSize: 12,
                              fontWeight: FontWeight.w600)),
                    ),
                  ))
              .toList(),
        ),
        const SizedBox(height: 4),
        for (int row = 0; row < rows; row++)
          Row(
            children: List.generate(7, (col) {
              final dayNum = row * 7 + col - startOffset + 1;
              if (dayNum < 1 || dayNum > lastDay.day) {
                return const Expanded(child: SizedBox(height: 44));
              }
              final day =
                  DateTime(_focusedMonth.year, _focusedMonth.month, dayNum);
              final isToday = day.year == today.year &&
                  day.month == today.month &&
                  day.day == today.day;
              final isSelected = _selectedDay != null &&
                  day.year == _selectedDay!.year &&
                  day.month == _selectedDay!.month &&
                  day.day == _selectedDay!.day;
              final dayTasks = TaskService.instance.forDate(day);

              return Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _selectedDay = day),
                  child: Container(
                    height: 44,
                    margin: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFF4A7BFF)
                          : isToday
                              ? const Color(0xFF4A7BFF).withValues(alpha: 0.15)
                              : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                      border: isToday && !isSelected
                          ? Border.all(color: const Color(0xFF4A7BFF), width: 1)
                          : null,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('$dayNum',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: isToday
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              fontSize: 13,
                            )),
                        if (dayTasks.isNotEmpty)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: dayTasks
                                .take(3)
                                .map((t) => Container(
                                      width: 5,
                                      height: 5,
                                      margin: const EdgeInsets.only(
                                          top: 2, left: 1),
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? Colors.white
                                            : (_priorityColors[t.priority] ??
                                                const Color(0xFF4A7BFF)),
                                        shape: BoxShape.circle,
                                      ),
                                    ))
                                .toList(),
                          )
                        else
                          const SizedBox(height: 7),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final dayTasks =
        _selectedDay != null ? TaskService.instance.forDate(_selectedDay!) : <Task>[];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar'),
        backgroundColor: const Color(0xFF000000),
      ),
      body: ListenableBuilder(
        listenable: TaskService.instance,
        builder: (context, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // ── Month grid ──────────────────────────────
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1A1A),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            onPressed: _previousMonth,
                            icon: const Icon(Icons.chevron_left,
                                color: Colors.white),
                          ),
                          Text(
                            '${_monthNames[_focusedMonth.month - 1]} ${_focusedMonth.year}',
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                fontWeight: FontWeight.bold),
                          ),
                          IconButton(
                            onPressed: _nextMonth,
                            icon: const Icon(Icons.chevron_right,
                                color: Colors.white),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      _buildCalendarGrid(),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // ── Day panel ───────────────────────────────
                if (_selectedDay != null)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A1A1A),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${_monthNames[_selectedDay!.month - 1]} ${_selectedDay!.day}, ${_selectedDay!.year}',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold),
                            ),
                            TextButton.icon(
                              onPressed: () => _openAddEvent(_selectedDay!),
                              icon: const Icon(Icons.add,
                                  color: Color(0xFF4A7BFF), size: 18),
                              label: const Text('Add',
                                  style: TextStyle(
                                      color: Color(0xFF4A7BFF), fontSize: 13)),
                            ),
                          ],
                        ),
                        const Divider(color: Colors.white12),
                        if (dayTasks.isEmpty)
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Text(
                              'No events — tap "Add" to create one.',
                              style: TextStyle(
                                  color: Colors.white38, fontSize: 13),
                            ),
                          )
                        else
                          ...dayTasks.map((t) => _TaskTile(
                                task: t,
                                onDelete: () async {
                                  await TaskService.instance.delete(t.id);
                                  setState(() {});
                                },
                                onToggle: () async {
                                  t.isDone = !t.isDone;
                                  await TaskService.instance.update(t);
                                  setState(() {});
                                },
                              )),
                      ],
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _TaskTile extends StatelessWidget {
  final Task task;
  final VoidCallback onDelete;
  final VoidCallback onToggle;
  const _TaskTile(
      {required this.task, required this.onDelete, required this.onToggle});

  static const _priorityColors = {
    'High': Color(0xFFFF4444),
    'Medium': Color(0xFFFFAA00),
    'Low': Color(0xFF4A7BFF),
  };

  @override
  Widget build(BuildContext context) {
    final color =
        _priorityColors[task.priority] ?? const Color(0xFF4A7BFF);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Icon(Icons.circle, color: color, size: 9),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    decoration: task.isDone
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                  ),
                ),
                if (task.description.isNotEmpty)
                  Text(task.description,
                      style: const TextStyle(
                          color: Colors.white54, fontSize: 12)),
                Row(children: [
                  _chip(task.category, color),
                  if (task.subject.isNotEmpty)
                    _chip(task.subject, Colors.white24),
                  if (task.time.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(left: 4),
                      child: Text(task.time,
                          style: const TextStyle(
                              color: Colors.white38, fontSize: 11)),
                    ),
                ]),
              ],
            ),
          ),
          Checkbox(
            value: task.isDone,
            onChanged: (_) => onToggle(),
            activeColor: const Color(0xFF4A7BFF),
            side: const BorderSide(color: Colors.white38),
          ),
          GestureDetector(
            onTap: onDelete,
            child: const Icon(Icons.delete_outline, color: Colors.red, size: 18),
          ),
        ],
      ),
    );
  }

  Widget _chip(String label, Color color) => Container(
        margin: const EdgeInsets.only(top: 3, right: 4),
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(label,
            style: TextStyle(color: color, fontSize: 10)),
      );
}
