import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';

class AppLayout extends StatelessWidget {
  const AppLayout({super.key, required this.child});

  final Widget child;

  static const _tabs = [
    _Tab(path: '/dashboard', label: 'Dashboard', icon: Icons.home_rounded),
    _Tab(path: '/history', label: 'History', icon: Icons.history_rounded),
    _Tab(path: '/devices', label: 'Devices', icon: Icons.memory_rounded),
    _Tab(path: '/alerts', label: 'Alerts', icon: Icons.notifications_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    final path = GoRouterState.of(context).uri.path;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.background, AppColors.backgroundBottom],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 80),
            child: child,
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: SizedBox(
            height: 64,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: _tabs.map((tab) {
                final isActive = path == tab.path;
                return InkWell(
                  onTap: () => context.go(tab.path),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          tab.icon,
                          size: 24,
                          color: isActive ? AppColors.primary : AppColors.textSecondary,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          tab.label,
                          style: TextStyle(
                            fontSize: 12,
                            color: isActive ? AppColors.primary : AppColors.textSecondary,
                            fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}

class _Tab {
  const _Tab({required this.path, required this.label, required this.icon});
  final String path;
  final String label;
  final IconData icon;
}
