import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../data/models/site.dart';
import '../../providers/energy_provider.dart';

class SiteDetailsScreen extends ConsumerWidget {
  const SiteDetailsScreen({super.key, required this.siteId});

  final String siteId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sites = ref.watch(energyProvider.select((s) => s.sites));
    Site? site;
    for (final s in sites) {
      if (s.id == siteId) {
        site = s;
        break;
      }
    }

    if (site == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Site')),
        body: const Center(child: Text('Site not found')),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios), onPressed: () => context.pop()),
        title: Text(site.name, style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600)),
        backgroundColor: AppColors.surface,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Location: ${site.location}', style: const TextStyle(color: AppColors.textPrimary)),
                  Text('Status: ${site.status.name}', style: const TextStyle(color: AppColors.textSecondary)),
                  Text('Capacity: ${site.capacity}', style: const TextStyle(color: AppColors.textSecondary)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
