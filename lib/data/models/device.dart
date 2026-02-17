/// Device model - mirrors React EnergyContext Device.
class Device {
  const Device({
    required this.id,
    required this.name,
    required this.type,
    required this.model,
    required this.serial,
    required this.firmware,
    required this.status,
    this.metrics,
  });

  final String id;
  final String name;
  final DeviceType type;
  final String model;
  final String serial;
  final String firmware;
  final DeviceStatus status;
  final DeviceMetrics? metrics;
}

class DeviceMetrics {
  const DeviceMetrics({
    this.output,
    this.production,
    this.soc,
    this.health,
  });

  final double? output;
  final double? production;
  final double? soc;
  final double? health;
}

enum DeviceType { inverter, battery, meter }

enum DeviceStatus { online, offline, warning }
