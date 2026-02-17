/// Energy data model - mirrors React EnergyContext EnergyData.
class EnergyData {
  const EnergyData({
    required this.solar,
    required this.consumption,
    required this.battery,
    required this.batteryPercent,
    required this.grid,
    required this.co2Saved,
    required this.savingsToday,
    required this.savingsMonth,
  });

  final double solar;
  final double consumption;
  final double battery;
  final double batteryPercent;
  final double grid;
  final int co2Saved;
  final double savingsToday;
  final double savingsMonth;

  EnergyData copyWith({
    double? solar,
    double? consumption,
    double? battery,
    double? batteryPercent,
    double? grid,
    int? co2Saved,
    double? savingsToday,
    double? savingsMonth,
  }) {
    return EnergyData(
      solar: solar ?? this.solar,
      consumption: consumption ?? this.consumption,
      battery: battery ?? this.battery,
      batteryPercent: batteryPercent ?? this.batteryPercent,
      grid: grid ?? this.grid,
      co2Saved: co2Saved ?? this.co2Saved,
      savingsToday: savingsToday ?? this.savingsToday,
      savingsMonth: savingsMonth ?? this.savingsMonth,
    );
  }
}
