class Task {
  final String id;
  String title;
  String description;
  String priority;      // 'High' | 'Medium' | 'Low'
  String category;      // 'Task' | 'Class' | 'Exam'
  String subject;
  String time;
  double estimatedHours;
  double completedHours;
  DateTime? dueDate;
  String status;        // 'To Do' | 'In Progress' | 'Done'

  bool get isDone => status == 'Done';
  set isDone(bool v) => status = v ? 'Done' : 'To Do';

  Task({
    required this.id,
    required this.title,
    this.description = '',
    this.priority = 'Medium',
    this.category = 'Task',
    this.subject = '',
    this.time = '',
    this.estimatedHours = 1.0,
    this.completedHours = 0.0,
    this.dueDate,
    this.status = 'To Do',
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
        'completedHours': completedHours,
        'dueDate': dueDate?.toIso8601String(),
        'status': status,
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
        completedHours: (map['completedHours'] as num?)?.toDouble() ?? 0.0,
        dueDate: map['dueDate'] != null
            ? DateTime.tryParse(map['dueDate'] as String)
            : null,
        status: (map['status'] as String?) ??
            ((map['isDone'] as int? ?? 0) == 1 ? 'Done' : 'To Do'),
      );
}
