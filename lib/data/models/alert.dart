/// Alert model - mirrors React EnergyContext Alert.
class Alert {
  const Alert({
    required this.id,
    required this.title,
    required this.message,
    required this.timestamp,
    required this.severity,
    required this.type,
    this.code,
    this.actions,
  });

  final String id;
  final String title;
  final String message;
  final DateTime timestamp;
  final AlertSeverity severity;
  final AlertType type;
  final String? code;
  final List<String>? actions;
}

enum AlertSeverity { critical, warning, info }

enum AlertType { system, grid, battery, firmware }
