import 'package:flutter/material.dart';
import '../services/units_service.dart';
import '../services/task_service.dart';
import '../models/unit_model.dart';
import 'subject_detail_page.dart';

class UnitsPage extends StatefulWidget {
  const UnitsPage({super.key});
  @override
  State<UnitsPage> createState() => _UnitsPageState();
}

class _UnitsPageState extends State<UnitsPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tab;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 2, vsync: this);
    TaskService.instance.load();
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Units'),
        backgroundColor: const Color(0xFF000000),
        elevation: 0,
        bottom: TabBar(
          controller: _tab,
          indicatorColor: const Color(0xFF4A7BFF),
          labelColor: const Color(0xFF4A7BFF),
          unselectedLabelColor: Colors.white38,
          tabs: const [
            Tab(text: 'All Units'),
            Tab(text: 'My Units'),
          ],
        ),
      ),
      body: ListenableBuilder(
        listenable: UnitsService.instance,
        builder: (context, _) => TabBarView(
          controller: _tab,
          children: [
            _AllUnitsTab(),
            _MyUnitsTab(onTabChange: () => _tab.animateTo(0)),
          ],
        ),
      ),
    );
  }
}

// ── All Units tab ─────────────────────────────────────────────────────────────

class _AllUnitsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final units = UnitsService.instance.allUnits;
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: units.length + 1,
      itemBuilder: (context, i) {
        if (i == 0) {
          return const Padding(
            padding: EdgeInsets.only(bottom: 16),
            child: Text(
              'Enrol in units to access tasks, your group, and the group chat.',
              style: TextStyle(color: Colors.white54, fontSize: 13),
            ),
          );
        }
        return _UnitCard(unit: units[i - 1]);
      },
    );
  }
}

class _UnitCard extends StatelessWidget {
  final UnitModel unit;
  const _UnitCard({required this.unit});

  @override
  Widget build(BuildContext context) {
    final enrolled = UnitsService.instance.isEnrolled(unit.id);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(14),
        border: enrolled
            ? Border.all(color: const Color(0xFF4A7BFF), width: 1.5)
            : null,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left: colour dot
            Container(
              width: 42, height: 42,
              decoration: BoxDecoration(
                color: const Color(0xFF4A7BFF).withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.school_outlined,
                  color: Color(0xFF4A7BFF), size: 22),
            ),
            const SizedBox(width: 12),
            // Middle: info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Text(unit.code,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold)),
                    const SizedBox(width: 8),
                    if (enrolled)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 7, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFF4A7BFF).withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text('Enrolled',
                            style: TextStyle(
                                color: Color(0xFF4A7BFF),
                                fontSize: 10,
                                fontWeight: FontWeight.w600)),
                      ),
                  ]),
                  const SizedBox(height: 2),
                  Text(unit.name,
                      style: const TextStyle(
                          color: Colors.white70, fontSize: 13)),
                  const SizedBox(height: 2),
                  Text('Lecturer: ${unit.lecturerName}',
                      style: const TextStyle(
                          color: Colors.white38, fontSize: 11)),
                ],
              ),
            ),
            // Right: button
            TextButton(
              onPressed: () => enrolled
                  ? UnitsService.instance.drop(unit.id)
                  : UnitsService.instance.enroll(unit.id),
              style: TextButton.styleFrom(
                backgroundColor: enrolled
                    ? Colors.red.withValues(alpha: 0.12)
                    : const Color(0xFF4A7BFF).withValues(alpha: 0.12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              ),
              child: Text(
                enrolled ? 'Drop' : 'Enrol',
                style: TextStyle(
                  color: enrolled ? Colors.red : const Color(0xFF4A7BFF),
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── My Units tab ──────────────────────────────────────────────────────────────

class _MyUnitsTab extends StatelessWidget {
  final VoidCallback onTabChange;
  const _MyUnitsTab({required this.onTabChange});

  @override
  Widget build(BuildContext context) {
    final enrolled = UnitsService.instance.enrolledUnits;
    if (enrolled.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.school_outlined, size: 56, color: Colors.white24),
            const SizedBox(height: 16),
            const Text("You haven't enrolled in any units yet.",
                style: TextStyle(color: Colors.white38, fontSize: 14)),
            const SizedBox(height: 12),
            TextButton(
              onPressed: onTabChange,
              child: const Text('Browse units',
                  style: TextStyle(color: Color(0xFF4A7BFF))),
            ),
          ],
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: enrolled.length,
      itemBuilder: (context, i) => _MyUnitCard(unit: enrolled[i]),
    );
  }
}

class _MyUnitCard extends StatelessWidget {
  final UnitModel unit;
  const _MyUnitCard({required this.unit});

  @override
  Widget build(BuildContext context) {
    final tasks = TaskService.instance.tasks
        .where((t) => t.subject == unit.code)
        .toList();
    final done = tasks.where((t) => t.isDone).length;
    final totalH =
        tasks.fold<double>(0, (s, t) => s + t.estimatedHours);
    final doneH =
        tasks.fold<double>(0, (s, t) => s + t.completedHours);
    final pct = totalH > 0 ? (doneH / totalH).clamp(0.0, 1.0) : 0.0;

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => SubjectDetailPage(unit: unit)),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFF4A7BFF).withValues(alpha: 0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(unit.code,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold)),
                    Text(unit.name,
                        style: const TextStyle(
                            color: Colors.white54, fontSize: 13)),
                    Text('Lecturer: ${unit.lecturerName}',
                        style: const TextStyle(
                            color: Colors.white38, fontSize: 11)),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('${(pct * 100).toInt()}%',
                      style: const TextStyle(
                          color: Color(0xFF4A7BFF),
                          fontSize: 18,
                          fontWeight: FontWeight.bold)),
                  Text('$done/${tasks.length} tasks',
                      style: const TextStyle(
                          color: Colors.white38, fontSize: 11)),
                ],
              ),
              const SizedBox(width: 8),
              const Icon(Icons.chevron_right, color: Colors.white38),
            ]),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: pct,
                backgroundColor: Colors.white12,
                valueColor: const AlwaysStoppedAnimation(Color(0xFF4A7BFF)),
                minHeight: 6,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              '${doneH.toStringAsFixed(1)}h / ${totalH.toStringAsFixed(1)}h completed',
              style:
                  const TextStyle(color: Colors.white38, fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }
}
