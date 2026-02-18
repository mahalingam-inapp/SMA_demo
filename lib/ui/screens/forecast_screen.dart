import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';

class ForecastScreen extends ConsumerStatefulWidget {
  const ForecastScreen({super.key});

  @override
  ConsumerState<ForecastScreen> createState() => _ForecastScreenState();
}

class _ForecastScreenState extends ConsumerState<ForecastScreen> {
  bool _isToday = true;

  static const _todayData = [
    {'hour': '6AM', 'expected': 0.5, 'actual': 0.4, 'weather': 'cloudy'},
    {'hour': '8AM', 'expected': 2.0, 'actual': 1.8, 'weather': 'cloudy'},
    {'hour': '10AM', 'expected': 4.5, 'actual': 4.2, 'weather': 'sun'},
    {'hour': '12PM', 'expected': 6.0, 'actual': 5.8, 'weather': 'sun'},
    {'hour': '2PM', 'expected': 5.5, 'actual': 5.3, 'weather': 'sun'},
    {'hour': '4PM', 'expected': 3.5, 'actual': 3.2, 'weather': 'cloudy'},
    {'hour': '6PM', 'expected': 1.0, 'actual': 0.9, 'weather': 'cloudy'},
    {'hour': '8PM', 'expected': 0.0, 'actual': 0.0, 'weather': 'cloudy'},
  ];

  static const _tomorrowData = [
    {'hour': '6AM', 'expected': 0.8, 'weather': 'sun'},
    {'hour': '8AM', 'expected': 2.5, 'weather': 'sun'},
    {'hour': '10AM', 'expected': 5.0, 'weather': 'sun'},
    {'hour': '12PM', 'expected': 6.5, 'weather': 'sun'},
    {'hour': '2PM', 'expected': 6.0, 'weather': 'sun'},
    {'hour': '4PM', 'expected': 4.0, 'weather': 'sun'},
    {'hour': '6PM', 'expected': 1.5, 'weather': 'cloudy'},
    {'hour': '8PM', 'expected': 0.0, 'weather': 'cloudy'},
  ];

  List<Map<String, dynamic>> get _data => _isToday ? _todayData : _tomorrowData;

  IconData _weatherIcon(String w) {
    switch (w) {
      case 'sun':
        return Icons.wb_sunny_rounded;
      case 'rain':
        return Icons.cloud_queue_rounded;
      case 'snow':
        return Icons.ac_unit_rounded;
      default:
        return Icons.cloud_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final totalExpected = _data.fold<double>(0, (s, d) => s + (d['expected'] as num).toDouble());
    final totalActual = _isToday
        ? _data.fold<double>(0, (s, d) => s + ((d['actual'] ?? 0) as num).toDouble())
        : null;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios, size: 20), onPressed: () => context.pop()),
        title: const Text('Energy Forecast', style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600)),
        backgroundColor: AppColors.surface,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Material(
                    color: _isToday ? AppColors.primary : AppColors.surface,
                    borderRadius: BorderRadius.circular(8),
                    child: InkWell(
                      onTap: () => setState(() => _isToday = true),
                      borderRadius: BorderRadius.circular(8),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Center(
                          child: Text(
                            'Today',
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: _isToday ? Colors.white : AppColors.textSecondary),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Material(
                    color: !_isToday ? AppColors.primary : AppColors.surface,
                    borderRadius: BorderRadius.circular(8),
                    child: InkWell(
                      onTap: () => setState(() => _isToday = false),
                      borderRadius: BorderRadius.circular(8),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Center(
                          child: Text(
                            'Tomorrow',
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: !_isToday ? Colors.white : AppColors.textSecondary),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Material(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  height: 260,
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
                              if (i >= 0 && i < _data.length) {
                                return Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: Text(_data[i]['hour'].toString(), style: const TextStyle(fontSize: 10, color: AppColors.textSecondary)),
                                );
                              }
                              return const SizedBox();
                            },
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 24,
                            getTitlesWidget: (v, meta) => Text('${v.toInt()}', style: const TextStyle(fontSize: 10, color: AppColors.textSecondary)),
                          ),
                        ),
                        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      ),
                      borderData: FlBorderData(show: false),
                      lineBarsData: [
                        LineChartBarData(
                          spots: _data.asMap().entries.map((e) => FlSpot(e.key.toDouble(), (e.value['expected'] as num).toDouble())).toList(),
                          isCurved: true,
                          color: AppColors.chartSolar,
                          barWidth: 2,
                          dashArray: [5, 5],
                          dotData: FlDotData(show: true),
                          belowBarData: BarAreaData(show: false),
                        ),
                        if (_isToday)
                          LineChartBarData(
                            spots: _data.asMap().entries.map((e) => FlSpot(e.key.toDouble(), ((e.value['actual'] ?? e.value['expected']) as num).toDouble())).toList(),
                            isCurved: true,
                            color: AppColors.chartSolar,
                            barWidth: 3,
                            dotData: FlDotData(show: true),
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Container(width: 16, height: 2, decoration: BoxDecoration(color: AppColors.chartSolar, borderRadius: BorderRadius.circular(1))),
                    const SizedBox(width: 6),
                    Text('Expected', style: TextStyle(fontSize: 12, color: AppColors.chartSolar.withOpacity(0.8))),
                  ],
                ),
                if (_isToday) ...[
                  const SizedBox(width: 24),
                  Row(
                    children: [
                      Container(width: 16, height: 2, color: AppColors.chartSolar),
                      const SizedBox(width: 6),
                      const Text('Actual', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                    ],
                  ),
                ],
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
                    const Text('Hourly Breakdown', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                    const SizedBox(height: 12),
                    ..._data.map((item) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            children: [
                              Icon(_weatherIcon(item['weather'].toString()), size: 24, color: item['weather'] == 'sun' ? AppColors.chartSolar : AppColors.textMuted),
                              const SizedBox(width: 12),
                              Text(item['hour'].toString(), style: const TextStyle(fontWeight: FontWeight.w500, color: AppColors.textPrimary)),
                              const Spacer(),
                              Text(
                                '${((item['actual'] ?? item['expected']) as num).toStringAsFixed(1)} kW',
                                style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                              ),
                            ],
                          ),
                        )),
                  ],
                ),
              ),
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
                    const Text('Summary', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                    const SizedBox(height: 12),
                    _summaryRow('Total Expected Generation:', '${totalExpected.toStringAsFixed(1)} kWh'),
                    if (totalActual != null) _summaryRow('Total Actual Generation:', '${totalActual.toStringAsFixed(1)} kWh'),
                    _summaryRow('Peak Generation Time:', '12PM - 2PM'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _summaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
          Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
        ],
      ),
    );
  }
}
