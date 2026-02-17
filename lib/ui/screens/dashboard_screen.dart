import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../data/models/site.dart';
import '../../providers/energy_provider.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {

  static const _historyData = [
    {'day': 'Mon', 'solar': 42.0, 'consumption': 38.0, 'export': 8.0},
    {'day': 'Tue', 'solar': 45.0, 'consumption': 35.0, 'export': 12.0},
    {'day': 'Wed', 'solar': 38.0, 'consumption': 40.0, 'export': 5.0},
    {'day': 'Thu', 'solar': 48.0, 'consumption': 36.0, 'export': 15.0},
    {'day': 'Fri', 'solar': 50.0, 'consumption': 38.0, 'export': 14.0},
    {'day': 'Sat', 'solar': 46.0, 'consumption': 42.0, 'export': 8.0},
    {'day': 'Sun', 'solar': 44.0, 'consumption': 40.0, 'export': 6.0},
  ];

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(energyProvider);
    final notifier = ref.read(energyProvider.notifier);
    final energyData = state.energyData;
    final currentSite = state.currentSite;
    final sites = state.sites;
    final alerts = state.alerts;
    final unreadCount = alerts.where((a) => a.severity.index <= 1).length;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            backgroundColor: AppColors.surface,
            title: Row(
              children: [
                const Text('SMA', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.primary)),
                const SizedBox(width: 8),
                Container(width: 32, height: 4, color: AppColors.accent),
              ],
            ),
            actions: [
              TextButton.icon(
                onPressed: () => _showSiteSelector(context, ref),
                icon: const Icon(Icons.keyboard_arrow_down, size: 20, color: AppColors.textSecondary),
                label: Text(currentSite.name, style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w500)),
              ),
              IconButton(
                onPressed: () => context.push('/alerts'),
                icon: Stack(
                  children: [
                    const Icon(Icons.notifications_outlined, color: AppColors.textPrimary),
                    if (unreadCount > 0)
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(color: AppColors.destructive, shape: BoxShape.circle),
                          child: Text('$unreadCount', style: const TextStyle(color: Colors.white, fontSize: 10)),
                        ),
                      ),
                  ],
                ),
              ),
              IconButton(onPressed: () => context.push('/settings'), icon: const Icon(Icons.menu, color: AppColors.textPrimary)),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 1.1,
                    children: [
                      _kpiCard('Solar Production', '${energyData.solar.toStringAsFixed(1)} kW', Icons.wb_sunny_rounded, [const Color(0xFFF97316), const Color(0xFFEA580C)]),
                      _kpiCard('Home Consumption', '${energyData.consumption.toStringAsFixed(1)} kW', Icons.home_rounded, [const Color(0xFF3B82F6), const Color(0xFF2563EB)]),
                      _kpiCard('Battery Level', '${energyData.batteryPercent.toStringAsFixed(0)}%', Icons.battery_charging_full_rounded, [const Color(0xFF10B981), const Color(0xFF059669)]),
                      _kpiCard('Grid Feed-In', '${energyData.grid.toStringAsFixed(1)} kW', Icons.bolt_rounded, [const Color(0xFF475569), const Color(0xFF334155)]),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text('Energy History (7 Days)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 220,
                    child: BarChart(
                      BarChartData(
                        alignment: BarChartAlignment.spaceAround,
                        maxY: 55,
                        barTouchData: BarTouchData(enabled: false),
                        titlesData: FlTitlesData(
                          show: true,
                          bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, getTitlesWidget: (v, meta) => Text(_historyData[v.toInt()]['day'] as String, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)))),
                          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 28, getTitlesWidget: (v, meta) => Text('${v.toInt()}', style: const TextStyle(fontSize: 10, color: AppColors.textSecondary)))),
                          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        ),
                        gridData: FlGridData(show: true, drawVerticalLine: false),
                        borderData: FlBorderData(show: false),
                        barGroups: [
                          for (int i = 0; i < _historyData.length; i++)
                            BarChartGroupData(
                              x: i,
                              barRods: [
                                BarChartRodData(toY: (_historyData[i]['solar'] as num).toDouble(), color: AppColors.chartSolar, width: 8, borderRadius: const BorderRadius.vertical(top: Radius.circular(4))),
                              ],
                              showingTooltipIndicators: [0],
                            ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: _smallCard(
                          Icons.eco_rounded,
                          'CO₂ Saved',
                          '${energyData.co2Saved} lbs',
                          'Today',
                          AppColors.success,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _smallCard(
                          Icons.attach_money_rounded,
                          'Savings',
                          '\$${energyData.savingsToday.toStringAsFixed(0)}',
                          '\$${energyData.savingsMonth.toStringAsFixed(0)} this month',
                          AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text('Quick Actions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                  const SizedBox(height: 12),
                  _listTile('View Energy Flow', () => context.push('/energy-flow')),
                  _listTile('Manage Devices', () => context.push('/devices')),
                  _listTile('View Programs', () => context.push('/programs')),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showSiteSelector(BuildContext context, WidgetRef ref) {
    final state = ref.read(energyProvider);
    final notifier = ref.read(energyProvider.notifier);
    showModalBottomSheet<void>(
      context: context,
      builder: (ctx) => _SiteSelectorSheet(
        sites: state.sites,
        currentSite: state.currentSite,
        onSelect: (id) {
          notifier.setSite(id);
          Navigator.pop(ctx);
        },
        onClose: () => Navigator.pop(ctx),
      ),
    );
  }

  Widget _kpiCard(String label, String value, IconData icon, List<Color> gradient) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: gradient),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: gradient[0].withOpacity(0.4), blurRadius: 8, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, color: Colors.white, size: 32),
          Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
          Text(label, style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.9))),
        ],
      ),
    );
  }

  Widget _smallCard(IconData icon, String label, String value, String sub, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 22, color: color),
              const SizedBox(width: 8),
              Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
            ],
          ),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
          Text(sub, style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
        ],
      ),
    );
  }

  Widget _listTile(String title, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10),
        child: ListTile(
          title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500, color: AppColors.textPrimary)),
          onTap: onTap,
        ),
      ),
    );
  }
}

class _SiteSelectorSheet extends StatelessWidget {
  const _SiteSelectorSheet({
    required this.sites,
    required this.currentSite,
    required this.onSelect,
    required this.onClose,
  });

  final List<Site> sites;
  final Site currentSite;
  final void Function(String id) onSelect;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 16, offset: Offset(0, -4))],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Select Site', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                IconButton(onPressed: onClose, icon: const Icon(Icons.close)),
              ],
            ),
            const SizedBox(height: 16),
            ...sites.map((site) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Material(
                    color: currentSite.id == site.id ? AppColors.primary.withOpacity(0.1) : null,
                    borderRadius: BorderRadius.circular(12),
                    child: InkWell(
                      onTap: () => onSelect(site.id),
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          border: Border.all(color: currentSite.id == site.id ? AppColors.primary : AppColors.border, width: 2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(site.name, style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                            Text(site.location, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: site.status == SiteStatus.active ? AppColors.success.withOpacity(0.15) : AppColors.textMuted.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(site.status.name, style: TextStyle(fontSize: 11, color: site.status == SiteStatus.active ? AppColors.success : AppColors.textSecondary)),
                                ),
                                const SizedBox(width: 8),
                                Text(site.capacity, style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
