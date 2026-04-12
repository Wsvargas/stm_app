import 'package:flutter/material.dart';
import 'login_page.dart';

class LecturerPage extends StatefulWidget {
  const LecturerPage({super.key});

  @override
  State<LecturerPage> createState() => _LecturerPageState();
}

class _LecturerPageState extends State<LecturerPage> {
  final List<Map<String, dynamic>> _assignments = [
    {
      'id': 1,
      'title': 'Flutter Basics Assignment',
      'description': 'Create a simple counter app',
      'dueDate': '2026-04-15',
      'totalMarks': 100,
    },
  ];

  void _addAssignment() {
    final titleCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    final dueDateCtrl = TextEditingController();
    final marksCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        title: const Text('Add New Assignment', style: TextStyle(color: Colors.white)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildField(titleCtrl, 'Assignment Title'),
              const SizedBox(height: 12),
              _buildField(descCtrl, 'Description', maxLines: 3),
              const SizedBox(height: 12),
              _buildField(dueDateCtrl, 'Due Date (YYYY-MM-DD)'),
              const SizedBox(height: 12),
              _buildField(marksCtrl, 'Total Marks', keyboardType: TextInputType.number),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.white70)),
          ),
          ElevatedButton(
            onPressed: () {
              if (titleCtrl.text.isNotEmpty &&
                  descCtrl.text.isNotEmpty &&
                  dueDateCtrl.text.isNotEmpty &&
                  marksCtrl.text.isNotEmpty) {
                setState(() {
                  _assignments.add({
                    'id': DateTime.now().millisecondsSinceEpoch,
                    'title': titleCtrl.text,
                    'description': descCtrl.text,
                    'dueDate': dueDateCtrl.text,
                    'totalMarks': int.parse(marksCtrl.text),
                  });
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Assignment added successfully')),
                );
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _editAssignment(int index) {
    final a = _assignments[index];
    final titleCtrl = TextEditingController(text: a['title']);
    final descCtrl = TextEditingController(text: a['description']);
    final dueDateCtrl = TextEditingController(text: a['dueDate']);
    final marksCtrl = TextEditingController(text: a['totalMarks'].toString());

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        title: const Text('Edit Assignment', style: TextStyle(color: Colors.white)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildField(titleCtrl, 'Assignment Title'),
              const SizedBox(height: 12),
              _buildField(descCtrl, 'Description', maxLines: 3),
              const SizedBox(height: 12),
              _buildField(dueDateCtrl, 'Due Date (YYYY-MM-DD)'),
              const SizedBox(height: 12),
              _buildField(marksCtrl, 'Total Marks', keyboardType: TextInputType.number),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.white70)),
          ),
          ElevatedButton(
            onPressed: () {
              if (titleCtrl.text.isNotEmpty) {
                setState(() {
                  _assignments[index] = {
                    'id': a['id'],
                    'title': titleCtrl.text,
                    'description': descCtrl.text,
                    'dueDate': dueDateCtrl.text,
                    'totalMarks': int.parse(marksCtrl.text),
                  };
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Assignment updated successfully')),
                );
              }
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  void _deleteAssignment(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        title: const Text('Delete Assignment', style: TextStyle(color: Colors.white)),
        content: const Text(
          'Are you sure you want to delete this assignment?',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.white70)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              setState(() => _assignments.removeAt(index));
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Assignment deleted')),
              );
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  Widget _buildField(TextEditingController ctrl, String hint,
      {int maxLines = 1, TextInputType keyboardType = TextInputType.text}) {
    return TextField(
      controller: ctrl,
      style: const TextStyle(color: Colors.white),
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white54),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Manage Assignments'),
        backgroundColor: const Color(0xFF000000),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const LoginPage()),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF4A7BFF),
        onPressed: _addAssignment,
        child: const Icon(Icons.add),
      ),
      body: _assignments.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.assignment, size: 64, color: Colors.white30),
                  SizedBox(height: 16),
                  Text('No assignments yet',
                      style: TextStyle(color: Colors.white70, fontSize: 18)),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _assignments.length,
              itemBuilder: (context, index) {
                final a = _assignments[index];
                return Card(
                  color: const Color(0xFF1A1A1A),
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(a['title'],
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 8),
                                  Text(a['description'],
                                      style: const TextStyle(
                                          color: Colors.white70, fontSize: 14)),
                                ],
                              ),
                            ),
                            Column(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit, color: Color(0xFF4A7BFF)),
                                  onPressed: () => _editAssignment(index),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => _deleteAssignment(index),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Due: ${a['dueDate']}',
                                style: const TextStyle(color: Colors.white54)),
                            Text('Marks: ${a['totalMarks']}',
                                style: const TextStyle(color: Colors.white54)),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
