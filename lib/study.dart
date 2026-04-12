import 'dart:async';
import 'package:flutter/material.dart';
import 'data.dart';

class StudyPage extends StatefulWidget {
  const StudyPage({super.key});

  @override
  State<StudyPage> createState() => _StudyPageState();
}

class _StudyPageState extends State<StudyPage> {
  int _minutes = 25;
  int _seconds = 0;
  bool _isRunning = false;
  bool _isBreak = false;
  Timer? _timer;

  int get _remainingSeconds => _minutes * 60 + _seconds;
  int get _sessionSeconds => _isBreak ? 10 * 60 : 25 * 60;
  double get _progress => _remainingSeconds / _sessionSeconds;
  String get _sessionLabel => _isBreak ? 'Break' : 'Study';

  void _startTimer() {
    if (_isRunning) return;
    setState(() => _isRunning = true);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_seconds > 0) {
          _seconds--;
        } else if (_minutes > 0) {
          _minutes--;
          _seconds = 59;
        } else {
          _timer?.cancel();
          _timer = null;
          _isRunning = false;
          if (_isBreak) {
            _minutes = 25;
            _seconds = 0;
            _isBreak = false;
            _snack('Break over! Back to study.');
          } else {
            _minutes = 10;
            _seconds = 0;
            _isBreak = true;
            _snack('Focus session complete! Take a break.');
          }
        }
        if (!_isBreak && _isRunning) {
          totalStudySeconds++;
        }
      });
    });
  }

  void _pauseTimer() {
    _timer?.cancel();
    _timer = null;
    setState(() => _isRunning = false);
  }

  void _resetTimer() {
    _timer?.cancel();
    _timer = null;
    setState(() {
      _minutes = 25;
      _seconds = 0;
      _isRunning = false;
      _isBreak = false;
    });
  }

  void _snack(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    double circleSize = screenWidth * 0.85;
    if (circleSize > screenHeight * 0.55) circleSize = screenHeight * 0.55;
    final strokeWidth = circleSize * 0.045;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text('Study With Me',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        child: Column(
          children: [
            const SizedBox(height: 16),

            // ── Timer circle ──────────────────────────────
            Expanded(
              child: Center(
                child: SizedBox(
                  width: circleSize,
                  height: circleSize,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Outer ring progress
                      SizedBox(
                        width: circleSize,
                        height: circleSize,
                        child: CircularProgressIndicator(
                          value: _progress,
                          strokeWidth: strokeWidth,
                          backgroundColor: Colors.white12,
                          color: Colors.white,
                        ),
                      ),
                      // Dot on top of ring
                      Positioned(
                        top: circleSize * 0.035,
                        child: Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.white38,
                                  blurRadius: 6,
                                  spreadRadius: 1)
                            ],
                          ),
                        ),
                      ),
                      // Center content
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _sessionLabel,
                            style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 16,
                                letterSpacing: 1.2),
                          ),
                          const SizedBox(height: 14),
                          Text(
                            '${_minutes.toString().padLeft(2, '0')}:${_seconds.toString().padLeft(2, '0')}',
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 52,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 2),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            _isBreak ? 'Break' : 'Focus',
                            style: const TextStyle(
                                color: Colors.white54, fontSize: 14),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // ── Control buttons ───────────────────────────
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isRunning ? null : _startTimer,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFDE90FE),
                      disabledBackgroundColor: const Color(0xFF9A60B0),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24)),
                    ),
                    child: const Text('Start',
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isRunning ? _pauseTimer : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF8A8AFF),
                      disabledBackgroundColor: const Color(0xFF555580),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24)),
                    ),
                    child: const Text('Pause',
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _resetTimer,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF444444),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24)),
                    ),
                    child: const Text('End',
                        style:
                            TextStyle(fontSize: 16, color: Colors.white)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // ── Quick-start chips ─────────────────────────
            Row(
              children: [
                _chip('Focus', '25 mins', onTap: () {
                  _pauseTimer();
                  setState(() {
                    _isBreak = false;
                    _minutes = 25;
                    _seconds = 0;
                  });
                }),
                const SizedBox(width: 8),
                _chip('Break', '10 mins', onTap: () {
                  _pauseTimer();
                  setState(() {
                    _isBreak = true;
                    _minutes = 10;
                    _seconds = 0;
                  });
                }),
                const SizedBox(width: 8),
                _chip('Study Hour',
                    '${(totalStudySeconds / 3600).toStringAsFixed(1)}h',
                    onTap: () => _snack(
                        'Total study time: ${(totalStudySeconds / 3600).toStringAsFixed(1)} hours')),
              ],
            ),
            const SizedBox(height: 28),
          ],
        ),
      ),
    );
  }

  Widget _chip(String label, String value, {VoidCallback? onTap}) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          decoration: BoxDecoration(
            color: const Color(0xFF1C1C1E),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              Text(value,
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w600)),
              const SizedBox(height: 4),
              Text(label,
                  style:
                      const TextStyle(color: Colors.white54, fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }
}
