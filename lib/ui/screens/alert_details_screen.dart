import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../data/models/alert.dart';
import '../../providers/energy_provider.dart';

class AlertDetailsScreen extends ConsumerWidget {
  const AlertDetailsScreen({super.key, required this.alertId});

  final String alertId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final alerts = ref.watch(energyProvider.select((s) => s.alerts));
    Alert? alertItem;
    for (final a in alerts) {
      if (a.id == alertId) {
        alertItem = a;
        break;
      }
    }

    if (alertItem == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Alert')),
        body: const Center(child: Text('Alert not found')),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios), onPressed: () => context.pop()),
        title: Text(alertItem.title, style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600)),
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
                  Text(alertItem.message, style: const TextStyle(color: AppColors.textPrimary)),
                  const SizedBox(height: 8),
                  Text('${alertItem.type.name} • ${alertItem.timestamp.toString().split('.').first}', style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                  if (alertItem.code != null) Text('Code: ${alertItem.code}', style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                  if (alertItem.actions != null && alertItem.actions!.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    const Text('Actions', style: TextStyle(fontWeight: FontWeight.w600)),
                    ...alertItem.actions!.map((a) => Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('• ', style: TextStyle(color: AppColors.textSecondary)),
                              Expanded(child: Text(a, style: const TextStyle(color: AppColors.textPrimary))),
                            ],
                          ),
                        )),
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
