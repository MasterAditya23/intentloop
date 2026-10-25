class Session {
  final String id;
  final String targetApp;
  final String intention;
  final DateTime startedAt;
  final int intendedDurationSeconds;
  
  DateTime? endedAt;
  int? observedUsageSeconds;
  String outcome; // 'stopped', 'extended', 'continued', or 'active'
  bool interventionShown;
  bool interventionAccepted;

  Session({
    required this.id,
    required this.targetApp,
    required this.intention,
    required this.startedAt,
    required this.intendedDurationSeconds,
    this.endedAt,
    this.observedUsageSeconds,
    this.outcome = 'active',
    this.interventionShown = false,
    this.interventionAccepted = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'targetApp': targetApp,
      'intention': intention,
      'startedAt': startedAt.toIso8601String(),
      'intendedDurationSeconds': intendedDurationSeconds,
      'endedAt': endedAt?.toIso8601String(),
      'observedUsageSeconds': observedUsageSeconds,
      'outcome': outcome,
      'interventionShown': interventionShown,
      'interventionAccepted': interventionAccepted,
    };
  }

  factory Session.fromJson(Map<String, dynamic> json) {
    return Session(
      id: json['id'],
      targetApp: json['targetApp'],
      intention: json['intention'],
      startedAt: DateTime.parse(json['startedAt']),
      intendedDurationSeconds: json['intendedDurationSeconds'],
      endedAt: json['endedAt'] != null ? DateTime.parse(json['endedAt']) : null,
      observedUsageSeconds: json['observedUsageSeconds'],
      outcome: json['outcome'] ?? 'active',
      interventionShown: json['interventionShown'] ?? false,
      interventionAccepted: json['interventionAccepted'] ?? false,
    );
  }
}