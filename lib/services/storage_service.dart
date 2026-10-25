import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/session.dart';

class StorageService {
  static const String _sessionsKey = 'intentloop_sessions';

  // Save a new session or update an existing one
  static Future<void> saveSession(Session session) async {
    final prefs = await SharedPreferences.getInstance();
    List<Session> sessions = await getSessions();

    // Check if session already exists, update it; otherwise insert at top
    int index = sessions.indexWhere((s) => s.id == session.id);
    if (index >= 0) {
      sessions[index] = session;
    } else {
      sessions.insert(0, session); // Insert new session at the top
      // Keep only the most recent 20 sessions to prevent endless growth
      if (sessions.length > 20) {
        sessions.removeLast();
      }
    }

    List<String> jsonList = sessions.map((s) => jsonEncode(s.toJson())).toList();
    await prefs.setStringList(_sessionsKey, jsonList);
  }

  // Load all saved sessions from local phone storage
  static Future<List<Session>> getSessions() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? jsonList = prefs.getStringList(_sessionsKey);
    
    if (jsonList == null) return [];

    return jsonList.map((item) => Session.fromJson(jsonDecode(item))).toList();
  }

  // Clear all history (useful for testing)
  static Future<void> clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_sessionsKey);
  }
}