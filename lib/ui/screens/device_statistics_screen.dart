import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../data/models/device.dart';
import '../../providers/energy_provider.dart';

class DeviceStatisticsScreen extends ConsumerWidget {
  const DeviceStatisticsScreen({super.key, required this.deviceId});

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
        appBar: AppBar(title: const Text('Statistics')),
        body: const Center(child: Text('Device not found')),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios, size: 20), onPressed: () => context.pop()),
        title: Text('${device.name} – Statistics', style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600)),
        backgroundColor: AppColors.surface,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Material(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Detailed Statistics', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                  const SizedBox(height: 8),
                  Text('Performance and usage data for this device.', style: TextStyle(fontSize: 14, color: AppColors.textSecondary)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
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
                    const Text('Current metrics', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                    const SizedBox(height: 16),
                    if (device.metrics!.output != null)
                      _statRow('Current output', '${device.metrics!.output} kW'),
                    if (device.metrics!.production != null)
                      _statRow('Total production', '${device.metrics!.production} kWh'),
                    if (device.metrics!.soc != null)
                      _statRow('State of charge', '${device.metrics!.soc!.toInt()}%'),
                    if (device.metrics!.health != null)
                      _statRow('Health', '${device.metrics!.health!.toInt()}%'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
          Material(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Historical data', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                  const SizedBox(height: 8),
                  Text(
                    'Daily output (last 7 days)',
                    style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 200,
                    child: BarChart(
                      BarChartData(
                        alignment: BarChartAlignment.spaceAround,
                        maxY: device.type == DeviceType.battery ? 100 : 60,
                        barTouchData: BarTouchData(enabled: false),
                        titlesData: FlTitlesData(
                          show: true,
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 28,
                              getTitlesWidget: (v, meta) {
                                const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                                final i = v.toInt();
                                if (i >= 0 && i < days.length) {
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 8),
                                    child: Text(days[i], style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                                  );
                                }
                                return const SizedBox();
                              },
                            ),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 28,
                              getTitlesWidget: (v, meta) => Text('${v.toInt()}', style: const TextStyle(fontSize: 10, color: AppColors.textSecondary)),
                            ),
                          ),
                          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        ),
                        gridData: FlGridData(show: true, drawVerticalLine: false),
                        borderData: FlBorderData(show: false),
                        barGroups: _buildHistoricalBarGroups(device.type),
                      ),
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

  /// Dummy 7-day historical values (kWh or % for battery).
  static List<BarChartGroupData> _buildHistoricalBarGroups(DeviceType type) {
    final values = type == DeviceType.battery
        ? [72.0, 68.0, 85.0, 90.0, 78.0, 82.0, 76.0] // SOC %
        : [38.0, 42.0, 35.0, 48.0, 52.0, 44.0, 46.0]; // kWh
    final color = type == DeviceType.battery ? AppColors.success : AppColors.chartSolar;
    return List.generate(7, (i) => BarChartGroupData(
      x: i,
      barRods: [
        BarChartRodData(
          toY: values[i],
          color: color,
          width: 10,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
        ),
      ],
      showingTooltipIndicators: [0],
    ));
  }

  Widget _statRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: AppColors.textSecondary)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
        ],
      ),
    );
  }
}
