import '../data/models/alert.dart';
import '../data/models/device.dart';
import '../data/models/energy_data.dart';
import '../data/models/site.dart';

/// Immutable state for the energy app (sites, currentSite, energyData, devices, alerts, auth).
class EnergyState {
  const EnergyState({
    required this.sites,
    required this.currentSiteId,
    required this.energyData,
    required this.devices,
    required this.alerts,
    required this.isAuthenticated,
  });

  final List<Site> sites;
  final String currentSiteId;
  final EnergyData energyData;
  final List<Device> devices;
  final List<Alert> alerts;
  final bool isAuthenticated;

  Site get currentSite {
    for (final s in sites) {
      if (s.id == currentSiteId) return s;
    }
    return sites.first;
  }

  EnergyState copyWith({
    List<Site>? sites,
    String? currentSiteId,
    EnergyData? energyData,
    List<Device>? devices,
    List<Alert>? alerts,
    bool? isAuthenticated,
  }) {
    return EnergyState(
      sites: sites ?? this.sites,
      currentSiteId: currentSiteId ?? this.currentSiteId,
      energyData: energyData ?? this.energyData,
      devices: devices ?? this.devices,
      alerts: alerts ?? this.alerts,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
    );
  }
}
