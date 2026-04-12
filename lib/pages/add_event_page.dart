import 'package:flutter/material.dart';

class AddEventPage extends StatefulWidget {
  final DateTime initialDate;
  const AddEventPage({super.key, required this.initialDate});

  @override
  State<AddEventPage> createState() => _AddEventPageState();
}

class _AddEventPageState extends State<AddEventPage> {
  String _category = 'Task';
  String _priority = 'Medium';
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  String? _subject;
  late DateTime _dueDate;
  TimeOfDay _time = const TimeOfDay(hour: 10, minute: 30);
  double _estimatedHours = 1.0;

  static const _categories = ['Task', 'Class', 'Exam'];
  static const _subjects = ['ICT305', 'ICT306', 'ICT307', 'ICT309', 'Other'];
  static const _priorities = ['High', 'Medium', 'Low'];
  static const _priorityColors = {
    'High': Color(0xFFFF4444),
    'Medium': Color(0xFFFFAA00),
    'Low': Color(0xFF4A7BFF),
  };

  static const _weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  static const _monthsShort = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
  ];

  @override
  void initState() {
    super.initState();
    _dueDate = widget.initialDate;
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueDate,
      firstDate: DateTime(2023),
      lastDate: DateTime(2030),
      builder: (context, child) => Theme(
        data: ThemeData.dark().copyWith(
          colorScheme: const ColorScheme.dark(
            primary: Color(0xFF4A7BFF),
            surface: Color(0xFF1A1A1A),
          ),
          dialogTheme: const DialogThemeData(backgroundColor: Color(0xFF0F0F0F)),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _dueDate = picked);
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _time,
      builder: (context, child) => Theme(
        data: ThemeData.dark().copyWith(
          colorScheme: const ColorScheme.dark(
            primary: Color(0xFF4A7BFF),
            surface: Color(0xFF1A1A1A),
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _time = picked);
  }

  void _save() {
    if (_titleCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a title')),
      );
      return;
    }
    Navigator.pop(context, {
      'title': _titleCtrl.text.trim(),
      'description': _descCtrl.text.trim(),
      'priority': _priority,
      'category': _category,
      'subject': _subject ?? '',
      'time': _time.format(context),
      'date': _dueDate.toIso8601String(),
      'estimatedHours': _estimatedHours.toString(),
    });
  }

  String _formatDate(DateTime d) =>
      '${_weekdays[d.weekday - 1]}, ${d.day} ${_monthsShort[d.month - 1]} ${d.year}';

  Widget _sectionLabel(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(text,
            style: const TextStyle(
                color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600)),
      );

  Widget _card({required Widget child}) => Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(12),
        ),
        child: child,
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF000000),
      appBar: AppBar(
        backgroundColor: const Color(0xFF000000),
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text('Add New',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)),
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Category tabs ──────────────────────────────
            Row(
              children: _categories.map((cat) {
                final selected = _category == cat;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _category = cat),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      margin: EdgeInsets.only(
                          right: cat == _categories.last ? 0 : 10),
                      padding: const EdgeInsets.symmetric(vertical: 11),
                      decoration: BoxDecoration(
                        color: selected ? const Color(0xFF4A7BFF) : Colors.transparent,
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(color: const Color(0xFF4A7BFF)),
                      ),
                      child: Text(
                        cat,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: selected ? Colors.white : const Color(0xFF4A7BFF),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 22),

            // ── Title ──────────────────────────────────────
            _sectionLabel('Title'),
            _card(
              child: TextField(
                controller: _titleCtrl,
                style: const TextStyle(color: Colors.white),
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'e.g. ICT307 Assignment 1',
                  hintStyle: TextStyle(color: Colors.white38),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(14),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // ── Description ────────────────────────────────
            _sectionLabel('Description (optional)'),
            _card(
              child: TextField(
                controller: _descCtrl,
                style: const TextStyle(color: Colors.white),
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: 'Add notes...',
                  hintStyle: TextStyle(color: Colors.white38),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(14),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // ── Priority ───────────────────────────────────
            _sectionLabel('Priority'),
            Row(
              children: _priorities.map((p) {
                final selected = _priority == p;
                final color = _priorityColors[p]!;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _priority = p),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      margin: EdgeInsets.only(right: p == 'Low' ? 0 : 10),
                      padding: const EdgeInsets.symmetric(vertical: 11),
                      decoration: BoxDecoration(
                        color: selected ? color.withValues(alpha: 0.2) : Colors.transparent,
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(color: color),
                      ),
                      child: Text(
                        p,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: color,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),

            // ── Estimated Hours ────────────────────────────
            _sectionLabel('Estimated Hours: ${_estimatedHours.toStringAsFixed(1)}h'),
            Row(
              children: [
                const Icon(Icons.access_time_filled, color: Color(0xFF4A7BFF), size: 18),
                Expanded(
                  child: Slider(
                    value: _estimatedHours,
                    min: 0.5,
                    max: 12.0,
                    divisions: 23,
                    activeColor: const Color(0xFF4A7BFF),
                    inactiveColor: Colors.white12,
                    onChanged: (v) => setState(() => _estimatedHours = v),
                  ),
                ),
                Text('${_estimatedHours.toStringAsFixed(1)}h',
                    style: const TextStyle(color: Colors.white70, fontSize: 13)),
              ],
            ),
            const SizedBox(height: 16),

            // ── Subject ────────────────────────────────────
            _sectionLabel('Subject'),
            _card(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: DropdownButton<String>(
                  value: _subject,
                  isExpanded: true,
                  underline: const SizedBox(),
                  dropdownColor: const Color(0xFF1A1A1A),
                  style: const TextStyle(color: Colors.white),
                  hint: const Text('Select subject', style: TextStyle(color: Colors.white38)),
                  items: _subjects
                      .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                      .toList(),
                  onChanged: (v) => setState(() => _subject = v),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // ── Due Date & Time ────────────────────────────
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _sectionLabel('Due Date'),
                      GestureDetector(
                        onTap: _pickDate,
                        child: _card(
                          child: Padding(
                            padding: const EdgeInsets.all(14),
                            child: Row(
                              children: [
                                const Icon(Icons.calendar_today,
                                    color: Color(0xFF4A7BFF), size: 16),
                                const SizedBox(width: 8),
                                Text(_formatDate(_dueDate),
                                    style: const TextStyle(color: Colors.white70, fontSize: 13)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _sectionLabel('Time'),
                      GestureDetector(
                        onTap: _pickTime,
                        child: _card(
                          child: Padding(
                            padding: const EdgeInsets.all(14),
                            child: Row(
                              children: [
                                const Icon(Icons.access_time,
                                    color: Color(0xFF4A7BFF), size: 16),
                                const SizedBox(width: 8),
                                Text(_time.format(context),
                                    style: const TextStyle(color: Colors.white70, fontSize: 13)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),

            // ── Save ───────────────────────────────────────
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4A7BFF),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(26)),
                ),
                child: const Text('Save',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 12),

            // ── Cancel ─────────────────────────────────────
            SizedBox(
              width: double.infinity,
              height: 52,
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFF4A7BFF)),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(26)),
                ),
                child: const Text('Cancel',
                    style: TextStyle(color: Color(0xFF4A7BFF), fontSize: 16)),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
