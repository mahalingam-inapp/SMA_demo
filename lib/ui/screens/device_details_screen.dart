import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../data/models/alert.dart';
import '../../data/models/device.dart';
import '../../providers/energy_provider.dart';

class DeviceDetailsScreen extends ConsumerWidget {
  const DeviceDetailsScreen({super.key, required this.deviceId});

  final String deviceId;

  static IconData _deviceIcon(DeviceType type) {
    switch (type) {
      case DeviceType.inverter:
        return Icons.memory;
      case DeviceType.battery:
        return Icons.battery_charging_full_rounded;
      case DeviceType.meter:
        return Icons.speed_rounded;
      default:
        return Icons.device_hub;
    }
  }

  static Color _deviceIconColor(DeviceType type) {
    switch (type) {
      case DeviceType.inverter:
        return AppColors.primary;
      case DeviceType.battery:
        return AppColors.success;
      case DeviceType.meter:
        return AppColors.chartSolar;
      default:
        return AppColors.textSecondary;
    }
  }

  static Color _statusColor(DeviceStatus status) {
    switch (status) {
      case DeviceStatus.online:
        return AppColors.success;
      case DeviceStatus.offline:
        return AppColors.destructive;
      case DeviceStatus.warning:
        return const Color(0xFFEAB308);
      default:
        return AppColors.textMuted;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final devices = ref.watch(energyProvider.select((s) => s.devices));
    final alerts = ref.watch(energyProvider.select((s) => s.alerts));
    Device? device;
    for (final d in devices) {
      if (d.id == deviceId) {
        device = d;
        break;
      }
    }

    if (device == null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text('Device', style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600)),
          backgroundColor: AppColors.surface,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Device not found', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => context.go('/devices'),
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                  child: const Text('Back to Devices'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final deviceAlerts = alerts.where((a) => a.type == AlertType.system).take(2).toList();
    final iconColor = _deviceIconColor(device.type);
    final statusColor = _statusColor(device.status);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios, size: 20), onPressed: () => context.pop()),
        title: const Text('Device Details', style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600)),
        backgroundColor: AppColors.surface,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Device Overview Card
          Material(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: iconColor.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(_deviceIcon(device.type), size: 40, color: iconColor),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(device.name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: statusColor.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(device.status.name, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: statusColor)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _detailRow('Model', device.model),
                  const Divider(height: 1),
                  _detailRow('Serial Number', device.serial),
                  const Divider(height: 1),
                  _detailRow('Firmware Version', device.firmware),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Performance Metrics Card
          if (device.metrics != null) ...[
            Material(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Performance Metrics', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                    const SizedBox(height: 16),
                    if (device.type == DeviceType.inverter && (device.metrics!.output != null || device.metrics!.production != null))
                      Row(
                        children: [
                          if (device.metrics!.output != null)
                            Expanded(
                              child: _metricBlock('Current Output', '${device.metrics!.output}', 'kW', AppColors.primary),
                            ),
                          if (device.metrics!.output != null && device.metrics!.production != null) const SizedBox(width: 16),
                          if (device.metrics!.production != null)
                            Expanded(
                              child: _metricBlock('Total Production', '${device.metrics!.production}', 'kWh', AppColors.chartSolar),
                            ),
                        ],
                      ),
                    if (device.type == DeviceType.battery && (device.metrics!.soc != null || device.metrics!.health != null))
                      Row(
                        children: [
                          if (device.metrics!.soc != null)
                            Expanded(
                              child: _metricBlock('State of Charge', '${device.metrics!.soc!.toInt()}', '%', AppColors.success),
                            ),
                          if (device.metrics!.soc != null && device.metrics!.health != null) const SizedBox(width: 16),
                          if (device.metrics!.health != null)
                            Expanded(
                              child: _metricBlock('Battery Health', '${device.metrics!.health!.toInt()}', '%', AppColors.primary),
                            ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
          // Recent Alerts Card
          if (deviceAlerts.isNotEmpty) ...[
            Material(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Recent Alerts', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                    const SizedBox(height: 12),
                    ...deviceAlerts.map((alert) {
                      final severityColor = alert.severity == AlertSeverity.critical
                          ? AppColors.destructive
                          : alert.severity == AlertSeverity.warning
                              ? const Color(0xFFEAB308)
                              : AppColors.primary;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Material(
                          color: AppColors.backgroundBottom,
                          borderRadius: BorderRadius.circular(8),
                          child: InkWell(
                            onTap: () => context.push('/alerts/${alert.id}'),
                            borderRadius: BorderRadius.circular(8),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(Icons.warning_amber_rounded, size: 22, color: severityColor),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(alert.title, style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                                        const SizedBox(height: 4),
                                        Text(alert.message, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
          // Actions Card
          Material(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Actions', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () => context.push('/devices/$deviceId/statistics'),
                      style: OutlinedButton.styleFrom(alignment: Alignment.centerLeft),
                      child: const Text('View Detailed Statistics'),
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () => context.push('/devices/$deviceId/firmware'),
                      style: OutlinedButton.styleFrom(alignment: Alignment.centerLeft),
                      child: const Text('Update Firmware'),
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () => context.push('/support'),
                      style: OutlinedButton.styleFrom(alignment: Alignment.centerLeft),
                      child: const Text('Contact Support'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 14, color: AppColors.textSecondary)),
          Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textPrimary)),
        ],
      ),
    );
  }

  Widget _metricBlock(String label, String value, String unit, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
        const SizedBox(height: 4),
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(value, style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: color)),
            const SizedBox(width: 4),
            Text(unit, style: TextStyle(fontSize: 16, color: color)),
          ],
        ),
      ],
    );
  }
}
