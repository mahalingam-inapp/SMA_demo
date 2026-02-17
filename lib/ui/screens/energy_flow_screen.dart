import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../providers/energy_provider.dart';

class EnergyFlowScreen extends ConsumerWidget {
  const EnergyFlowScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final energyData = ref.watch(energyProvider.select((s) => s.energyData));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios), onPressed: () => context.go('/dashboard')),
        title: const Text('Energy Flow', style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600)),
        backgroundColor: AppColors.surface,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _flowNode('Solar', '${energyData.solar.toStringAsFixed(1)} kW', Icons.wb_sunny_rounded, AppColors.chartSolar),
              const SizedBox(height: 24),
              _flowNode('Battery', '${energyData.batteryPercent.toStringAsFixed(0)}%', Icons.battery_charging_full_rounded, AppColors.success),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _flowNode('Home', '${energyData.consumption.toStringAsFixed(1)} kW', Icons.home_rounded, AppColors.primary),
                  _flowNode('Grid', '${energyData.grid.toStringAsFixed(1)} kW', Icons.bolt_rounded, AppColors.textSecondary),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _flowNode(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: color.withValues(alpha: 0.3), blurRadius: 8, offset: const Offset(0, 4))],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
              Text(value, style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
            ],
          ),
        ],
      ),
    );
  }
}
