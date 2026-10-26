import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import '../models/session.dart';
import '../services/storage_service.dart';

class ActiveSessionScreen extends StatefulWidget {
  final Session session;

  const ActiveSessionScreen({
    super.key,
    required this.session,
  });

  @override
  State<ActiveSessionScreen> createState() => _ActiveSessionScreenState();
}

class _ActiveSessionScreenState extends State<ActiveSessionScreen> {
  late Timer _timer;
  late int _remainingSeconds;

  @override
  void initState() {
    super.initState();
    _remainingSeconds = widget.session.intendedDurationSeconds;
    
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        _timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String get timerString {
    int minutes = _remainingSeconds ~/ 60;
    int seconds = _remainingSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

 void _finishSession(String outcome) async {
    widget.session.outcome = outcome;
    widget.session.endedAt = DateTime.now();
    
    // Save to the local database before leaving the screen!
    await StorageService.saveSession(widget.session);
    
    if (mounted) {
      Navigator.pop(context);
    }
  }
  void _addMoreTime() {
    setState(() {
      _remainingSeconds += 300; // Adds exactly 5 minutes
    });
    // Restart timer if it had reached zero
    if (!_timer.isActive) {
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_remainingSeconds > 0) {
          setState(() {
            _remainingSeconds--;
          });
        } else {
          _timer.cancel();
        }
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'YOUR CURRENT INTENTION',
                style: TextStyle(
                  color: Colors.deepPurpleAccent, 
                  fontSize: 14,
                  letterSpacing: 1.5,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                widget.session.intention,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 60),
              Text(
                timerString,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 72,
                  fontWeight: FontWeight.bold,
                  fontFeatures: [FontFeature.tabularFigures()],
                ),
              ),
              const SizedBox(height: 12),
              Text(
                _remainingSeconds > 0 ? 'Time Remaining' : 'Time is up!',
                style: TextStyle(
                  color: _remainingSeconds > 0 ? Colors.grey : Colors.redAccent, 
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 60),
              
              // 1. "I have done all" Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: () => _finishSession('completed'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurpleAccent,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  icon: const Icon(Icons.check_circle_outline, size: 24),
                  label: const Text(
                    'I have done all I needed', 
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // 2. "I want more time" Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: OutlinedButton.icon(
                  onPressed: _addMoreTime,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: BorderSide(color: Colors.deepPurpleAccent.withOpacity(0.5), width: 2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  icon: const Icon(Icons.add_alarm, size: 22),
                  label: const Text(
                    'I want more time (+5 min)', 
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // 3. End Early Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: TextButton(
                  onPressed: () => _finishSession('abandoned'),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.grey,
                  ),
                  child: const Text('End Session Early', style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}