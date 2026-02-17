import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../providers/energy_provider.dart';

class SiteManagementScreen extends ConsumerWidget {
  const SiteManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sites = ref.watch(energyProvider.select((s) => s.sites));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios), onPressed: () => context.pop()),
        title: const Text('Site Management', style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600)),
        backgroundColor: AppColors.surface,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: sites.length,
        itemBuilder: (_, i) {
          final site = sites[i];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              title: Text(site.name, style: const TextStyle(fontWeight: FontWeight.w500)),
              subtitle: Text(site.location),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push('/settings/sites/${site.id}'),
            ),
          );
        },
      ),
    );
  }
}
