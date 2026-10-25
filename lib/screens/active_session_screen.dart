import 'dart:async';
import 'package:flutter/material.dart';
import '../models/session.dart';
import '../services/storage_service.dart';

class ActiveSessionScreen extends StatefulWidget {
  final Session session;
  const ActiveSessionScreen({super.key, required this.session});

  @override
  State<ActiveSessionScreen> createState() => _ActiveSessionScreenState();
}

class _ActiveSessionScreenState extends State<ActiveSessionScreen> {
  late Timer _timer;
  int _secondsElapsed = 0;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _secondsElapsed++;
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _finishSession(String outcome) async {
    widget.session.endedAt = DateTime.now();
    widget.session.observedUsageSeconds = _secondsElapsed;
    widget.session.outcome = outcome;
    await StorageService.saveSession(widget.session);

    if (!mounted) return;
    Navigator.pop(context); // Return to Home
  }

  @override
  Widget build(BuildContext context) {
    int targetSecs = widget.session.intendedDurationSeconds;
    int remainingSecs = targetSecs - _secondsElapsed;
    bool isOvertime = remainingSecs < 0;
    int displaySecs = isOvertime ? _secondsElapsed - targetSecs : remainingSecs;

    String timeFormatted = '${(displaySecs ~/ 60).toString().padLeft(2, '0')}:${(displaySecs % 60).toString().padLeft(2, '0')}';

    return WillPopScope(
      onWillPop: () async => false, // Prevent accidental back button press
      child: Scaffold(
        backgroundColor: const Color(0xFF121212),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.deepPurpleAccent.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Active Session: ${widget.session.targetApp}',
                    style: const TextStyle(color: Colors.deepPurpleAccent, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  isOvertime ? 'Overtime By' : 'Time Remaining',
                  style: const TextStyle(color: Colors.grey, fontSize: 16),
                ),
                const SizedBox(height: 12),
                Text(
                  timeFormatted,
                  style: TextStyle(
                    color: isOvertime ? Colors.redAccent : Colors.white,
                    fontSize: 64,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 32),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E1E1E),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade900),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'Your Intention:',
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '"${widget.session.intention}"',
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.white, fontSize: 16, fontStyle: FontStyle.italic),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 48),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton.icon(
                    onPressed: () => _finishSession('stopped'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade700,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    icon: const Icon(Icons.check_circle_outline_rounded),
                    label: const Text('I am done. Close App.', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: OutlinedButton.icon(
                    onPressed: () => _finishSession('extended'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.orangeAccent,
                      side: const BorderSide(color: Colors.orangeAccent),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    icon: const Icon(Icons.more_time_rounded),
                    label: const Text('I need more time', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}