import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../providers/energy_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logout = ref.read(energyProvider.notifier).logout;

    final sections = [
      _Section(title: 'Account', items: [
        _Item(label: 'Profile', icon: Icons.person_outline, path: '/settings/profile'),
        _Item(label: 'Site Management', icon: Icons.home_work_outlined, path: '/settings/sites'),
      ]),
      _Section(title: 'System', items: [
        _Item(label: 'Device Pairing', icon: Icons.link, path: '/devices'),
        _Item(label: 'Notifications', icon: Icons.notifications_outlined, path: '/settings/notifications'),
      ]),
      _Section(title: 'Programs', items: [
        _Item(label: 'Manage Programs', icon: Icons.emoji_events_outlined, path: '/programs'),
      ]),
      _Section(title: 'App', items: [
        _Item(label: 'Language', icon: Icons.language, path: '/settings/language'),
        _Item(label: 'Units', icon: Icons.straighten_outlined, path: '/settings'),
        _Item(label: 'About', icon: Icons.info_outline, path: '/settings/about'),
      ]),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Settings', style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600)),
        backgroundColor: AppColors.surface,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        children: [
          ...sections.map((section) => Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8, bottom: 8),
                      child: Text(
                        section.title.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    Material(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(12),
                      elevation: 2,
                      child: ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: section.items.length,
                        separatorBuilder: (_, __) => const Divider(height: 1),
                        itemBuilder: (_, i) {
                          final item = section.items[i];
                          return ListTile(
                            leading: Icon(item.icon, size: 22, color: AppColors.textSecondary),
                            title: Text(item.label, style: const TextStyle(fontWeight: FontWeight.w500, color: AppColors.textPrimary)),
                            trailing: const Icon(Icons.chevron_right, color: AppColors.textMuted),
                            onTap: () => context.push(item.path),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              )),
          Material(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            elevation: 2,
            child: ListTile(
              leading: const Icon(Icons.logout_rounded, color: AppColors.destructive, size: 22),
              title: const Text('Log Out', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.destructive)),
              onTap: () async {
                final ok = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Log out?'),
                    content: const Text('Are you sure you want to log out?'),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
                      TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Log Out')),
                    ],
                  ),
                );
                if (ok == true) {
                  logout();
                  if (context.mounted) context.go('/');
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _Section {
  const _Section({required this.title, required this.items});
  final String title;
  final List<_Item> items;
}

class _Item {
  const _Item({required this.label, required this.icon, required this.path});
  final String label;
  final IconData icon;
  final String path;
}
