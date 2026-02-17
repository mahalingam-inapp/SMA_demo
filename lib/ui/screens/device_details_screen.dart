import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../data/models/device.dart';
import '../../providers/energy_provider.dart';

class DeviceDetailsScreen extends ConsumerWidget {
  const DeviceDetailsScreen({super.key, required this.deviceId});

  final String deviceId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final devices = ref.watch(energyProvider.select((s) => s.devices));
    Device? device;
    for (final d in devices) {
      if (d.id == deviceId) {
        device = d;
        break;
      }
    }

    if (device == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Device')),
        body: const Center(child: Text('Device not found')),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios), onPressed: () => context.pop()),
        title: Text(device.name, style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600)),
        backgroundColor: AppColors.surface,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Model: ${device.model}', style: const TextStyle(color: AppColors.textPrimary)),
                  Text('Serial: ${device.serial}', style: const TextStyle(color: AppColors.textSecondary)),
                  Text('Firmware: ${device.firmware}', style: const TextStyle(color: AppColors.textSecondary)),
                  Text('Status: ${device.status.name}', style: const TextStyle(color: AppColors.textSecondary)),
                  if (device.metrics != null) ...[
                    const SizedBox(height: 12),
                    const Text('Metrics', style: TextStyle(fontWeight: FontWeight.w600)),
                    if (device.metrics!.output != null) Text('Output: ${device.metrics!.output} kW'),
                    if (device.metrics!.production != null) Text('Production: ${device.metrics!.production} kWh'),
                    if (device.metrics!.soc != null) Text('SOC: ${device.metrics!.soc}%'),
                    if (device.metrics!.health != null) Text('Health: ${device.metrics!.health}%'),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
