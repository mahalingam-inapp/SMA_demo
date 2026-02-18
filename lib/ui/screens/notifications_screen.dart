import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';

class NotificationsScreen extends ConsumerStatefulWidget {
  const NotificationsScreen({super.key});

  @override
  ConsumerState<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen> {
  bool _enabled = true;
  bool _system = true;
  bool _grid = true;
  bool _battery = true;
  bool _vpp = false;
  bool _hems = false;
  bool _quietHours = true;
  bool _sound = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios, size: 20), onPressed: () => context.pop()),
        title: const Text('Notifications', style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600)),
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
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Enable Notifications', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                          const SizedBox(height: 4),
                          Text('Receive alerts about your energy system', style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                        ],
                      ),
                    ),
                    Switch(
                      value: _enabled,
                      onChanged: (v) => setState(() => _enabled = v),
                      activeColor: AppColors.primary,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Padding(
              padding: EdgeInsets.only(left: 8, bottom: 8),
              child: Text('CATEGORIES', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textSecondary, letterSpacing: 0.5)),
            ),
            Material(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              elevation: 2,
              child: Column(
                children: [
                  _switchTile('System Alerts', 'Inverter, battery, and device status', _system, (v) => setState(() => _system = v)),
                  const Divider(height: 1),
                  _switchTile('Grid Alerts', 'Outages and power quality', _grid, (v) => setState(() => _grid = v)),
                  const Divider(height: 1),
                  _switchTile('Battery Alerts', 'SOC levels and charging status', _battery, (v) => setState(() => _battery = v)),
                  const Divider(height: 1),
                  _switchTile('VPP Events', 'Virtual power plant participation', _vpp, (v) => setState(() => _vpp = v)),
                  const Divider(height: 1),
                  _switchTile('HEMS Updates', 'Energy management system changes', _hems, (v) => setState(() => _hems = v)),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Padding(
              padding: EdgeInsets.only(left: 8, bottom: 8),
              child: Text('PREFERENCES', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textSecondary, letterSpacing: 0.5)),
            ),
            Material(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              elevation: 2,
              child: Column(
                children: [
                  _switchTile('Quiet Hours', '10:00 PM - 7:00 AM', _quietHours, (v) => setState(() => _quietHours = v)),
                  const Divider(height: 1),
                  _switchTile('Sound', 'Play sound with notifications', _sound, (v) => setState(() => _sound = v)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _switchTile(String title, String subtitle, bool value, ValueChanged<bool> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: AppColors.textPrimary)),
                const SizedBox(height: 2),
                Text(subtitle, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: _enabled ? onChanged : null,
            activeColor: AppColors.primary,
          ),
        ],
      ),
    );
  }
}
