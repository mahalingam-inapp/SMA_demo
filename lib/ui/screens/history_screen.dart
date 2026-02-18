import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../providers/energy_provider.dart';

class HistoryScreen extends ConsumerStatefulWidget {
  const HistoryScreen({super.key});

  @override
  ConsumerState<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen> {
  String _period = 'week';

  List<Map<String, dynamic>> _getHistoryData() {
    switch (_period) {
      case 'day':
        return List.generate(24, (i) => {
          'time': '$i:00',
          'solar': 2.0 + (i >= 6 && i <= 18 ? (i - 6) * 0.5 : 0.0) + (i >= 12 && i <= 16 ? 2.0 : 0.0),
          'consumption': 2.5 + (i >= 8 && i <= 22 ? 1.5 : 0.0),
          'grid': 0.5 + (i >= 10 && i <= 14 ? 1.5 : 0.0),
        });
      case 'week':
        return [
          {'time': 'Mon', 'solar': 42.0, 'consumption': 38.0, 'grid': 8.0},
          {'time': 'Tue', 'solar': 45.0, 'consumption': 35.0, 'grid': 12.0},
          {'time': 'Wed', 'solar': 38.0, 'consumption': 40.0, 'grid': 5.0},
          {'time': 'Thu', 'solar': 48.0, 'consumption': 36.0, 'grid': 15.0},
          {'time': 'Fri', 'solar': 50.0, 'consumption': 38.0, 'grid': 14.0},
          {'time': 'Sat', 'solar': 46.0, 'consumption': 42.0, 'grid': 8.0},
          {'time': 'Sun', 'solar': 44.0, 'consumption': 40.0, 'grid': 6.0},
        ];
      case 'month':
        return List.generate(30, (i) => {
          'time': '${i + 1}',
          'solar': 35.0 + (i % 7) * 3.0,
          'consumption': 30.0 + (i % 5) * 2.0,
          'grid': 8.0 + (i % 4),
        });
      case 'year':
        return [
          {'time': 'Jan', 'solar': 380.0, 'consumption': 420.0, 'grid': 120.0},
          {'time': 'Feb', 'solar': 450.0, 'consumption': 390.0, 'grid': 150.0},
          {'time': 'Mar', 'solar': 520.0, 'consumption': 380.0, 'grid': 180.0},
          {'time': 'Apr', 'solar': 580.0, 'consumption': 350.0, 'grid': 220.0},
          {'time': 'May', 'solar': 650.0, 'consumption': 340.0, 'grid': 280.0},
          {'time': 'Jun', 'solar': 680.0, 'consumption': 360.0, 'grid': 300.0},
          {'time': 'Jul', 'solar': 670.0, 'consumption': 380.0, 'grid': 290.0},
          {'time': 'Aug', 'solar': 640.0, 'consumption': 370.0, 'grid': 270.0},
          {'time': 'Sep', 'solar': 560.0, 'consumption': 360.0, 'grid': 210.0},
          {'time': 'Oct', 'solar': 480.0, 'consumption': 380.0, 'grid': 160.0},
          {'time': 'Nov', 'solar': 400.0, 'consumption': 400.0, 'grid': 120.0},
          {'time': 'Dec', 'solar': 360.0, 'consumption': 420.0, 'grid': 100.0},
        ];
      default:
        return [
          {'time': 'Mon', 'solar': 42.0, 'consumption': 38.0, 'grid': 8.0},
          {'time': 'Tue', 'solar': 45.0, 'consumption': 35.0, 'grid': 12.0},
          {'time': 'Wed', 'solar': 38.0, 'consumption': 40.0, 'grid': 5.0},
          {'time': 'Thu', 'solar': 48.0, 'consumption': 36.0, 'grid': 15.0},
          {'time': 'Fri', 'solar': 50.0, 'consumption': 38.0, 'grid': 14.0},
          {'time': 'Sat', 'solar': 46.0, 'consumption': 42.0, 'grid': 8.0},
          {'time': 'Sun', 'solar': 44.0, 'consumption': 40.0, 'grid': 6.0},
        ];
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(energyProvider);
    final data = _getHistoryData();
    final totalSolar = data.fold<double>(0, (s, d) => s + (d['solar'] as num).toDouble());
    final totalConsumption = data.fold<double>(0, (s, d) => s + (d['consumption'] as num).toDouble());
    final totalGrid = data.fold<double>(0, (s, d) => s + (d['grid'] as num).toDouble());
    final selfConsumptionPct = totalSolar > 0 ? (totalConsumption / totalSolar * 100).clamp(0.0, 100.0) : 0.0;
    final exportPct = totalSolar > 0 ? (totalGrid / totalSolar * 100).clamp(0.0, 100.0) : 0.0;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Energy History', style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600)),
        backgroundColor: AppColors.surface,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _periodTabs(),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: _summaryCard('Solar (kWh)', totalSolar.toStringAsFixed(1), AppColors.chartSolar)),
                const SizedBox(width: 12),
                Expanded(child: _summaryCard('Consumption (kWh)', totalConsumption.toStringAsFixed(1), AppColors.chartConsumption)),
                const SizedBox(width: 12),
                Expanded(child: _summaryCard('Grid Export (kWh)', totalGrid.toStringAsFixed(1), AppColors.chartExport)),
              ],
            ),
            const SizedBox(height: 16),
            Material(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  height: 280,
                  child: LineChart(
                    LineChartData(
                      gridData: FlGridData(show: true, drawVerticalLine: false),
                      titlesData: FlTitlesData(
                        show: true,
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 28,
                            getTitlesWidget: (v, meta) {
                              final i = v.toInt();
                              if (i >= 0 && i < data.length) {
                                final t = data[i]['time'].toString();
                                return Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: Text(t.length > 4 ? t.substring(0, 3) : t, style: const TextStyle(fontSize: 10, color: AppColors.textSecondary)),
                                );
                              }
                              return const SizedBox();
                            },
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 32,
                            getTitlesWidget: (v, meta) => Text('${v.toInt()}', style: const TextStyle(fontSize: 10, color: AppColors.textSecondary)),
                          ),
                        ),
                        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      ),
                      borderData: FlBorderData(show: false),
                      lineBarsData: [
                        LineChartBarData(
                          spots: data.asMap().entries.map((e) => FlSpot(e.key.toDouble(), (e.value['solar'] as num).toDouble())).toList(),
                          isCurved: true,
                          color: AppColors.chartSolar,
                          barWidth: 2,
                          dotData: FlDotData(show: data.length <= 14),
                          belowBarData: BarAreaData(show: false),
                        ),
                        LineChartBarData(
                          spots: data.asMap().entries.map((e) => FlSpot(e.key.toDouble(), (e.value['consumption'] as num).toDouble())).toList(),
                          isCurved: true,
                          color: AppColors.chartConsumption,
                          barWidth: 2,
                          dotData: FlDotData(show: data.length <= 14),
                          belowBarData: BarAreaData(show: false),
                        ),
                        LineChartBarData(
                          spots: data.asMap().entries.map((e) => FlSpot(e.key.toDouble(), (e.value['grid'] as num).toDouble())).toList(),
                          isCurved: true,
                          color: AppColors.chartExport,
                          barWidth: 2,
                          dotData: FlDotData(show: data.length <= 14),
                          belowBarData: BarAreaData(show: false),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _legendDot(AppColors.chartSolar, 'Solar'),
                const SizedBox(width: 16),
                _legendDot(AppColors.chartConsumption, 'Consumption'),
                const SizedBox(width: 16),
                _legendDot(AppColors.chartExport, 'Grid Export'),
              ],
            ),
            const SizedBox(height: 24),
            Material(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Performance Metrics', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                    const SizedBox(height: 16),
                    _metricRow('Self-Consumption', selfConsumptionPct, AppColors.chartConsumption),
                    const SizedBox(height: 12),
                    _metricRow('Export Rate', exportPct, AppColors.chartExport),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _periodTabs() {
    final periods = ['day', 'week', 'month', 'year'];
    return Row(
      children: periods.map((p) {
        final selected = _period == p;
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Material(
              color: selected ? AppColors.primary : AppColors.surface,
              borderRadius: BorderRadius.circular(8),
              child: InkWell(
                onTap: () => setState(() => _period = p),
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Center(
                    child: Text(
                      p[0].toUpperCase() + p.substring(1),
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: selected ? Colors.white : AppColors.textSecondary,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _summaryCard(String label, String value, Color color) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(12),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          children: [
            Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
            const SizedBox(height: 4),
            Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
          ],
        ),
      ),
    );
  }

  Widget _legendDot(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 12, height: 12, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
      ],
    );
  }

  Widget _metricRow(String label, double pct, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
            Text('${pct.toStringAsFixed(0)}%', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: pct / 100,
            backgroundColor: AppColors.border,
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 8,
          ),
        ),
      ],
    );
  }
}
