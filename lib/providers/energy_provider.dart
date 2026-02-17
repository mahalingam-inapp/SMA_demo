import 'dart:async';
import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/alert.dart';
import '../data/models/device.dart';
import '../data/models/energy_data.dart';
import '../data/models/site.dart';
import 'energy_state.dart';

final energyProvider =
    NotifierProvider<EnergyNotifier, EnergyState>(EnergyNotifier.new);

class EnergyNotifier extends Notifier<EnergyState> {
  Timer? _simulationTimer;

  static List<Site> get _sites => [
        const Site(
          id: 'site-1',
          name: 'My Home',
          location: '123 Solar Street, San Francisco, CA',
          status: SiteStatus.active,
          capacity: '10.5 kW',
          devices: ['inv-1', 'bat-1', 'met-1'],
          programs: ['SREC'],
        ),
        const Site(
          id: 'site-2',
          name: 'Vacation Home',
          location: '456 Beach Ave, Miami, FL',
          status: SiteStatus.active,
          capacity: '8.2 kW',
          devices: ['inv-2', 'bat-2'],
          programs: [],
        ),
      ];

  static List<Device> get _devices => [
        const Device(
          id: 'inv-1',
          name: 'Main Inverter',
          type: DeviceType.inverter,
          model: 'SMA Sunny Boy XYZ123',
          serial: 'SB-2024-001234',
          firmware: 'v3.2.1',
          status: DeviceStatus.online,
          metrics: DeviceMetrics(output: 5.5, production: 48.2),
        ),
        const Device(
          id: 'bat-1',
          name: 'Home Battery',
          type: DeviceType.battery,
          model: 'SMA Battery AB300',
          serial: 'BAT-2024-005678',
          firmware: 'v2.1.0',
          status: DeviceStatus.online,
          metrics: DeviceMetrics(soc: 76, health: 98),
        ),
        const Device(
          id: 'met-1',
          name: 'Energy Meter',
          type: DeviceType.meter,
          model: 'SMA Grid Watch GW100',
          serial: 'GW-2024-009876',
          firmware: 'v1.5.2',
          status: DeviceStatus.online,
        ),
      ];

  static List<Alert> get _alerts => [
        Alert(
          id: 'alert-1',
          title: 'Inverter Fault',
          message: 'Main inverter detected overcurrent condition',
          timestamp: DateTime.now().subtract(const Duration(hours: 2)),
          severity: AlertSeverity.critical,
          type: AlertType.system,
          code: 'ERR-INV-401',
          actions: const [
            'Check AC connections',
            'Reset inverter',
            'Contact support if persists',
          ],
        ),
        Alert(
          id: 'alert-2',
          title: 'Grid Outage Detected',
          message: 'System switched to backup mode',
          timestamp: DateTime.now().subtract(const Duration(hours: 5)),
          severity: AlertSeverity.warning,
          type: AlertType.grid,
          actions: const [
            'Monitor system status',
            'Battery providing backup power',
          ],
        ),
        Alert(
          id: 'alert-3',
          title: 'Low Battery Warning',
          message: 'Battery SOC below 20%',
          timestamp: DateTime.now().subtract(const Duration(days: 1)),
          severity: AlertSeverity.warning,
          type: AlertType.battery,
          actions: const [
            'Consider reducing consumption',
            'Battery will charge from solar/grid',
          ],
        ),
        Alert(
          id: 'alert-4',
          title: 'Firmware Update Available',
          message: 'New firmware v3.3.0 available for inverter',
          timestamp: DateTime.now().subtract(const Duration(days: 3)),
          severity: AlertSeverity.info,
          type: AlertType.firmware,
          actions: const [
            'Review release notes',
            'Schedule update during low production',
          ],
        ),
      ];

  static EnergyData get _initialEnergyData => const EnergyData(
        solar: 5.5,
        consumption: 3.0,
        battery: 2.5,
        batteryPercent: 76,
        grid: 2.5,
        co2Saved: 45,
        savingsToday: 18,
        savingsMonth: 120,
      );

  @override
  EnergyState build() {
    return EnergyState(
      sites: _sites,
      currentSiteId: 'site-1',
      energyData: _initialEnergyData,
      devices: _devices,
      alerts: _alerts,
      isAuthenticated: false,
    );
  }

  void login(String email, String password) {
    state = state.copyWith(isAuthenticated: true);
    _startSimulation();
  }

  void logout() {
    _simulationTimer?.cancel();
    _simulationTimer = null;
    state = EnergyState(
      sites: _sites,
      currentSiteId: 'site-1',
      energyData: _initialEnergyData,
      devices: _devices,
      alerts: _alerts,
      isAuthenticated: false,
    );
  }

  void signup(String email, String password, String name, String country) {
    state = state.copyWith(isAuthenticated: true);
    _startSimulation();
  }

  void setSite(String siteId) {
    state = state.copyWith(currentSiteId: siteId);
  }

  void _startSimulation() {
    _simulationTimer?.cancel();
    _simulationTimer = Timer.periodic(const Duration(seconds: 15), (_) {
      final d = state.energyData;
      final r = Random();
      state = state.copyWith(
        energyData: d.copyWith(
          solar: (d.solar + (r.nextDouble() - 0.5) * 0.5).clamp(0.0, double.infinity),
          consumption: (d.consumption + (r.nextDouble() - 0.5) * 0.3).clamp(0.0, double.infinity),
          battery: (d.battery + (r.nextDouble() - 0.5) * 0.2).clamp(0.0, double.infinity),
          batteryPercent: (d.batteryPercent + (r.nextDouble() - 0.5) * 2).clamp(0.0, 100.0),
          grid: (d.grid + (r.nextDouble() - 0.5) * 0.4).clamp(0.0, double.infinity),
        ),
      );
    });
  }
}
