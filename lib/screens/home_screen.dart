import 'dart:async';
import 'package:flutter/material.dart';
import 'session_setup_screen.dart';
import 'history_screen.dart';
import '../services/usage_service.dart';
import '../services/notification_service.dart';
import '../services/storage_service.dart'; // Added storage import

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _hasUsagePermission = false;
  int _completedSessions = 0;
  int _totalSessions = 0;

  @override
  void initState() {
    super.initState();
    _checkPermission();
    _loadStats(); // Load stats on startup
  }

  Future<void> _checkPermission() async {
    bool granted = await UsageService.hasPermission();
    setState(() {
      _hasUsagePermission = granted;
    });
  }

  // Calculates the user's Mindful Score from local storage
  Future<void> _loadStats() async {
    final sessions = await StorageService.getSessions();
    if (mounted) {
      setState(() {
        _totalSessions = sessions.length;
        _completedSessions = sessions.where((s) => s.outcome == 'completed').length;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.deepPurpleAccent.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.hourglass_empty_rounded,
                      color: Colors.deepPurpleAccent,
                      size: 32,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'IntentLoop',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                      Text(
                        'Break the scroll. Own your time.',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const Spacer(),
              if (!_hasUsagePermission)
                Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.orange.withOpacity(0.4)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '⚠️ System Permission Required',
                        style: TextStyle(color: Colors.orangeAccent, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'To automatically detect distracting apps, IntentLoop needs Usage Access permission.',
                        style: TextStyle(color: Colors.grey, fontSize: 13),
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: () async {
                          await UsageService.requestPermission();
                          await Future.delayed(const Duration(seconds: 2));
                          _checkPermission();
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                        child: const Text('Grant Usage Access', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
              
              // NEW GAMIFICATION DASHBOARD
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E1E),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.deepPurpleAccent.withOpacity(0.3)),
                ),
                child: Column(
                  children: [
                    const Text(
                      '🌟 Mindful Score',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            Text(
                              '$_completedSessions',
                              style: const TextStyle(color: Colors.greenAccent, fontSize: 32, fontWeight: FontWeight.bold),
                            ),
                            const Text('Intentions Kept', style: TextStyle(color: Colors.grey, fontSize: 12)),
                          ],
                        ),
                        Container(width: 1, height: 40, color: Colors.grey.shade800),
                        Column(
                          children: [
                            Text(
                              '$_totalSessions',
                              style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
                            ),
                            const Text('Total Sessions', style: TextStyle(color: Colors.grey, fontSize: 12)),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    // await allows the home screen to refresh stats when returning
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SessionSetupScreen(),
                      ),
                    );
                    _loadStats(); 
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurpleAccent,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  icon: const Icon(Icons.play_arrow_rounded, size: 24),
                  label: const Text(
                    'Start Mindful Session',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: OutlinedButton.icon(
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HistoryScreen(),
                      ),
                    );
                    _loadStats();
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: BorderSide(color: Colors.grey.shade800),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  icon: const Icon(Icons.history_rounded, size: 22),
                  label: const Text(
                    'View Session History',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: TextButton.icon(
                  onPressed: () async {
                    final TimeOfDay? selectedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    
                    if (selectedTime != null) {
                      await NotificationService.scheduleDailyReminder(selectedTime);
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Daily reminder set for ${selectedTime.format(context)}'),
                            backgroundColor: Colors.deepPurple,
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      }
                    }
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  icon: const Icon(Icons.alarm_add_rounded, size: 22),
                  label: const Text(
                    'Set Daily Reminder',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}