class Task {
  final String id;
  String title;
  String description;
  String priority; // 'High', 'Medium', 'Low'
  String category; // 'Task', 'Class', 'Exam'
  String subject;
  String time;
  double estimatedHours; // NEW: horas estimadas
  DateTime? dueDate;
  bool isDone;

  Task({
    required this.id,
    required this.title,
    this.description = '',
    this.priority = 'Medium',
    this.category = 'Task',
    this.subject = '',
    this.time = '',
    this.estimatedHours = 1.0,
    this.dueDate,
    this.isDone = false,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'description': description,
        'priority': priority,
        'category': category,
        'subject': subject,
        'time': time,
        'estimatedHours': estimatedHours,
        'dueDate': dueDate?.toIso8601String(),
        'isDone': isDone ? 1 : 0,
      };

  factory Task.fromMap(Map<String, dynamic> map) => Task(
        id: map['id'] as String,
        title: map['title'] as String,
        description: (map['description'] as String?) ?? '',
        priority: (map['priority'] as String?) ?? 'Medium',
        category: (map['category'] as String?) ?? 'Task',
        subject: (map['subject'] as String?) ?? '',
        time: (map['time'] as String?) ?? '',
        estimatedHours: (map['estimatedHours'] as num?)?.toDouble() ?? 1.0,
        dueDate: map['dueDate'] != null
            ? DateTime.tryParse(map['dueDate'] as String)
            : null,
        isDone: (map['isDone'] as int? ?? 0) == 1,
      );
}
