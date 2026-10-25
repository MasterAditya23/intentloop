import 'package:flutter/material.dart';
import '../models/session.dart';
import '../services/storage_service.dart';
import 'active_session_screen.dart';

class SessionSetupScreen extends StatefulWidget {
  const SessionSetupScreen({super.key});

  @override
  State<SessionSetupScreen> createState() => _SessionSetupScreenState();
}

class _SessionSetupScreenState extends State<SessionSetupScreen> {
  final _intentionController = TextEditingController();
  String _selectedApp = 'Instagram';
  int _selectedMinutes = 15;

  final List<String> _apps = ['Instagram', 'YouTube', 'TikTok', 'Twitter / X', 'Reddit', 'Other'];
  final List<int> _durations = [5, 15, 30, 45, 60];

  void _startSession() async {
    if (_intentionController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please write down your intention first!')),
      );
      return;
    }

    final newSession = Session(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      targetApp: _selectedApp,
      intention: _intentionController.text.trim(),
      startedAt: DateTime.now(),
      intendedDurationSeconds: _selectedMinutes * 60,
    );

    await StorageService.saveSession(newSession);

    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ActiveSessionScreen(session: newSession),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('New Mindful Session', style: TextStyle(color: Colors.white)),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: ListView(
            children: [
              const Text(
                '1. What app are you opening?',
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                children: _apps.map((app) {
                  bool isSelected = _selectedApp == app;
                  return ChoiceChip(
                    label: Text(app),
                    selected: isSelected,
                    selectedColor: Colors.deepPurpleAccent,
                    backgroundColor: const Color(0xFF1E1E1E),
                    labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.grey),
                    onSelected: (selected) {
                      setState(() => _selectedApp = app);
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 32),
              const Text(
                '2. What is your explicit intention?',
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _intentionController,
                maxLines: 3,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'e.g., Reply to Sarah\'s message about tonight\'s dinner plan...',
                  hintStyle: TextStyle(color: Colors.grey.shade600),
                  filled: true,
                  fillColor: const Color(0xFF1E1E1E),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                '3. How many minutes do you need?',
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: _durations.map((mins) {
                  bool isSelected = _selectedMinutes == mins;
                  return InkWell(
                    onTap: () => setState(() => _selectedMinutes = mins),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.deepPurpleAccent : const Color(0xFF1E1E1E),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected ? Colors.deepPurpleAccent : Colors.grey.shade800,
                        ),
                      ),
                      child: Text(
                        '${mins}m',
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 48),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _startSession,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurpleAccent,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: const Text('Commit & Open App', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}