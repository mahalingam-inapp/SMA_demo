import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../data/models/device.dart';
import '../../providers/energy_provider.dart';

class DevicesScreen extends ConsumerWidget {
  const DevicesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final devices = ref.watch(energyProvider.select((s) => s.devices));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Devices', style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600)),
        backgroundColor: AppColors.surface,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: devices.length,
        itemBuilder: (_, i) {
          final d = devices[i];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: Icon(_iconForType(d.type), color: AppColors.primary),
              title: Text(d.name, style: const TextStyle(fontWeight: FontWeight.w500)),
              subtitle: Text('${d.model} • ${d.status.name}'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push('/devices/${d.id}'),
            ),
          );
        },
      ),
    );
  }

  IconData _iconForType(DeviceType type) {
    switch (type) {
      case DeviceType.inverter:
        return Icons.flash_on_rounded;
      case DeviceType.battery:
        return Icons.battery_charging_full_rounded;
      case DeviceType.meter:
        return Icons.speed_rounded;
    }
  }
}
