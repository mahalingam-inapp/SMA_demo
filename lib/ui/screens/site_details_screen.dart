import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../data/models/device.dart';
import '../../data/models/site.dart';
import '../../providers/energy_provider.dart';

class SiteDetailsScreen extends ConsumerWidget {
  const SiteDetailsScreen({super.key, required this.siteId});

  final String siteId;

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
    final state = ref.watch(energyProvider);
    final sites = state.sites;
    final devices = state.devices;
    Site? site;
    for (final s in sites) {
      if (s.id == siteId) {
        site = s;
        break;
      }
    }

    if (site == null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text('Site', style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600)),
          backgroundColor: AppColors.surface,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Site not found', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => context.go('/settings/sites'),
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                  child: const Text('Back to Sites'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final siteDeviceIds = site.devices;
    final siteDevices = devices.where((d) => siteDeviceIds.contains(d.id)).toList();
    final isActive = site.status == SiteStatus.active;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios, size: 20), onPressed: () => context.pop()),
        title: const Text('Site Details', style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600)),
        backgroundColor: AppColors.surface,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Site Overview Card
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(site.name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(Icons.location_on_outlined, size: 18, color: AppColors.textSecondary),
                                const SizedBox(width: 6),
                                Expanded(child: Text(site.location, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary))),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: isActive ? AppColors.success.withOpacity(0.15) : AppColors.textMuted.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(site.status.name, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: isActive ? AppColors.success : AppColors.textSecondary)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Divider(height: 1),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Icon(Icons.bolt_rounded, size: 22, color: AppColors.primary),
                      const SizedBox(width: 8),
                      const Text('System Capacity:', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(site.capacity, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.primary)),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {},
                      child: const Text('Edit Site Information'),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Devices Card
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
                    children: [
                      const Icon(Icons.memory, size: 22, color: AppColors.primary),
                      const SizedBox(width: 8),
                      Text('Devices (${siteDevices.length})', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (siteDevices.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Text('No devices', style: TextStyle(fontSize: 14, color: AppColors.textSecondary)),
                    )
                  else
                    ...siteDevices.map((device) {
                      final statusColor = _statusColor(device.status);
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.backgroundBottom,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(device.name, style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                                    const SizedBox(height: 2),
                                    Text(device.model, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: statusColor.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(device.status.name, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: statusColor)),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Programs Card
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
                    children: [
                      const Icon(Icons.emoji_events_outlined, size: 22, color: AppColors.chartSolar),
                      const SizedBox(width: 8),
                      const Text('Enrolled Programs', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (site.programs.isEmpty)
                    const Text('No programs enrolled', style: TextStyle(fontSize: 14, color: AppColors.textSecondary))
                  else
                    ...site.programs.map((program) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.success.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(program, style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                          ),
                        )),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
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
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(alignment: Alignment.centerLeft),
                      child: const Text('View Performance History'),
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () => context.push('/devices'),
                      style: OutlinedButton.styleFrom(alignment: Alignment.centerLeft),
                      child: const Text('Manage Devices'),
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(alignment: Alignment.centerLeft, foregroundColor: AppColors.destructive),
                      child: const Text('Remove Site'),
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
}
