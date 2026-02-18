import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';

class HEMSConfigScreen extends ConsumerStatefulWidget {
  const HEMSConfigScreen({super.key});

  @override
  ConsumerState<HEMSConfigScreen> createState() => _HEMSConfigScreenState();
}

class _HEMSConfigScreenState extends ConsumerState<HEMSConfigScreen> {
  double _minSOC = 20;
  bool _gridCharging = false;
  bool _saved = false;

  final _loadPriority = [
    {'id': 1, 'name': 'Critical Loads', 'priority': 1},
    {'id': 2, 'name': 'Refrigerator', 'priority': 2},
    {'id': 3, 'name': 'HVAC', 'priority': 3},
    {'id': 4, 'name': 'Water Heater', 'priority': 4},
  ];

  void _save() {
    setState(() => _saved = true);
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        setState(() => _saved = false);
        context.pop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios, size: 20), onPressed: () => context.pop()),
        title: const Text('HEMS Configuration', style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600)),
        backgroundColor: AppColors.surface,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Material(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Battery Settings', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Minimum State of Charge', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textPrimary)),
                        Text('${_minSOC.toInt()}%', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.primary)),
                      ],
                    ),
                    Slider(
                      value: _minSOC,
                      min: 10,
                      max: 50,
                      divisions: 8,
                      activeColor: AppColors.primary,
                      onChanged: (v) => setState(() => _minSOC = v),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Battery will not discharge below this level during normal operation',
                      style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 16),
                    const Divider(height: 1),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Grid Charging', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: AppColors.textPrimary)),
                              SizedBox(height: 2),
                              Text('Allow battery to charge from grid', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                            ],
                          ),
                        ),
                        Switch(
                          value: _gridCharging,
                          onChanged: (v) => setState(() => _gridCharging = v),
                          activeColor: AppColors.primary,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Material(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Load Priority', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                    const SizedBox(height: 8),
                    const Text(
                      'Set the order in which loads are powered during backup mode',
                      style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 16),
                    ..._loadPriority.map((load) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            children: [
                              Icon(Icons.drag_handle, size: 22, color: AppColors.textMuted),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(load['name'] as String, style: const TextStyle(fontWeight: FontWeight.w500, color: AppColors.textPrimary)),
                                    Text('Priority ${load['priority']}', style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Material(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Rate Schedule', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                    const SizedBox(height: 8),
                    const Text(
                      'Configure utility rate periods for time-of-use optimization',
                      style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 16),
                    _rateChip('Peak Rate', '4:00 PM - 9:00 PM', '\$0.42/kWh', const Color(0xFFF97316)),
                    const SizedBox(height: 8),
                    _rateChip('Mid-Peak Rate', '7:00 AM - 4:00 PM', '\$0.28/kWh', const Color(0xFFEAB308)),
                    const SizedBox(height: 8),
                    _rateChip('Off-Peak Rate', '9:00 PM - 7:00 AM', '\$0.18/kWh', AppColors.success),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () {},
                        child: const Text('Edit Rate Schedule'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _saved ? null : _save,
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                icon: Icon(_saved ? Icons.check : Icons.save, size: 20),
                label: Text(_saved ? 'Configuration Saved!' : 'Save Configuration'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _rateChip(String title, String subtitle, String rate, Color accent) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: accent.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border(left: BorderSide(color: accent, width: 4)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(fontWeight: FontWeight.w600, color: accent.withOpacity(0.9))),
              const SizedBox(height: 2),
              Text(subtitle, style: TextStyle(fontSize: 12, color: accent.withOpacity(0.8))),
            ],
          ),
          Text(rate, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: accent)),
        ],
      ),
    );
  }
}
