import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../data/models/alert.dart';
import '../../providers/energy_provider.dart';

class AlertsScreen extends ConsumerWidget {
  const AlertsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final alerts = ref.watch(energyProvider.select((s) => s.alerts));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Alerts', style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600)),
        backgroundColor: AppColors.surface,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: alerts.length,
        itemBuilder: (_, i) {
          final a = alerts[i];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: Icon(_iconForSeverity(a.severity), color: _colorForSeverity(a.severity)),
              title: Text(a.title, style: const TextStyle(fontWeight: FontWeight.w500)),
              subtitle: Text(a.message, maxLines: 1, overflow: TextOverflow.ellipsis),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push('/alerts/${a.id}'),
            ),
          );
        },
      ),
    );
  }

  IconData _iconForSeverity(AlertSeverity s) {
    switch (s) {
      case AlertSeverity.critical:
        return Icons.error_rounded;
      case AlertSeverity.warning:
        return Icons.warning_amber_rounded;
      case AlertSeverity.info:
        return Icons.info_outline_rounded;
    }
  }

  Color _colorForSeverity(AlertSeverity s) {
    switch (s) {
      case AlertSeverity.critical:
        return AppColors.destructive;
      case AlertSeverity.warning:
        return Colors.orange;
      case AlertSeverity.info:
        return AppColors.primary;
    }
  }
}
