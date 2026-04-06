import 'package:flutter/material.dart';

class AnalyticsPage extends StatelessWidget {
  const AnalyticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black, // background color for the page
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // AppBar replacement
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    'Analytics',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  
                ],
              ),
              const SizedBox(height: 20),

              const Text(
                "Performance Stats",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              // Stats row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  AnalyticsCard(
                    label: 'Tasks Completed',
                    value: '8/12',
                    color: Colors.blue,
                  ),
                  AnalyticsCard(
                    label: 'Study Hours',
                    value: '15h',
                    color: Colors.green,
                  ),
                  AnalyticsCard(
                    label: 'Units Completed',
                    value: '5/6',
                    color: Colors.orange,
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Graph placeholder
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFF1C1C1E),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Center(
                  child: Text(
                    '📊 Graph Placeholder',
                    style: TextStyle(color: Colors.white54),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                "Recent Activity",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              const ActivityCard(
                title: 'Completed ICT306 Assignment',
                subtitle: '2 hours ago',
              ),
              const ActivityCard(
                title: 'Attended Group Study ICT305',
                subtitle: 'Yesterday',
              ),
              const ActivityCard(
                title: 'Submitted Project ICT309',
                subtitle: '3 days ago',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Single stat card
class AnalyticsCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const AnalyticsCard(
      {super.key, required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1E),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(color: Colors.white70, fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// Recent activity card
class ActivityCard extends StatelessWidget {
  final String title;
  final String subtitle;

  const ActivityCard({super.key, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1E),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Icon(Icons.check_circle_outline, color: Colors.blue),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(subtitle, style: const TextStyle(color: Colors.grey)),
              ],
            ),
          )
        ],
      ),
    );
  }
}