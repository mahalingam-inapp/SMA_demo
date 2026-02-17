/// Site model - mirrors React EnergyContext Site.
class Site {
  const Site({
    required this.id,
    required this.name,
    required this.location,
    required this.status,
    required this.capacity,
    required this.devices,
    required this.programs,
  });

  final String id;
  final String name;
  final String location;
  final SiteStatus status;
  final String capacity;
  final List<String> devices;
  final List<String> programs;
}

enum SiteStatus { active, inactive }
