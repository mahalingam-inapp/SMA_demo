import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';

class AboutScreen extends ConsumerWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios, size: 20), onPressed: () => context.pop()),
        title: const Text('About', style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600)),
        backgroundColor: AppColors.surface,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // App Info Card (centered)
          Material(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 24),
              child: Column(
                children: [
                  const Text('SMA', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.primary)),
                  const SizedBox(height: 8),
                  Container(width: 64, height: 4, color: AppColors.accent),
                  const SizedBox(height: 16),
                  const Text('SMA Energy App', style: TextStyle(fontSize: 14, color: AppColors.textSecondary)),
                  const SizedBox(height: 4),
                  const Text('Version 3.2.1 (Build 20250217)', style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          // App Info Details Card
          Material(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _aboutRow('Release Date', 'February 17, 2026'),
                  const Divider(height: 24),
                  _aboutRow('Last Update', 'Today'),
                  const Divider(height: 24),
                  _aboutRow('Copyright', '© 2026 SMA Solar Technology'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Links Card
          Material(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            elevation: 2,
            child: Column(
              children: [
                ListTile(
                  title: const Text('Terms of Service', style: TextStyle(fontWeight: FontWeight.w500, color: AppColors.textPrimary)),
                  trailing: const Icon(Icons.open_in_new, size: 18, color: AppColors.textMuted),
                  onTap: () {},
                ),
                const Divider(height: 1),
                ListTile(
                  title: const Text('Privacy Policy', style: TextStyle(fontWeight: FontWeight.w500, color: AppColors.textPrimary)),
                  trailing: const Icon(Icons.open_in_new, size: 18, color: AppColors.textMuted),
                  onTap: () {},
                ),
                const Divider(height: 1),
                ListTile(
                  title: const Text('Legal Information', style: TextStyle(fontWeight: FontWeight.w500, color: AppColors.textPrimary)),
                  trailing: const Icon(Icons.open_in_new, size: 18, color: AppColors.textMuted),
                  onTap: () {},
                ),
                const Divider(height: 1),
                ListTile(
                  title: const Text('Open Source Licenses', style: TextStyle(fontWeight: FontWeight.w500, color: AppColors.textPrimary)),
                  trailing: const Icon(Icons.open_in_new, size: 18, color: AppColors.textMuted),
                  onTap: () {},
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {},
              child: const Text('Check for Updates'),
            ),
          ),
          const SizedBox(height: 16),
          // Support Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.08),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.primary.withOpacity(0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Need Help?', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.primary)),
                const SizedBox(height: 8),
                const Text(
                  'Visit our support portal or contact our customer service team for assistance.',
                  style: TextStyle(fontSize: 14, color: AppColors.textPrimary),
                ),
                const SizedBox(height: 12),
                OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(foregroundColor: AppColors.primary, side: const BorderSide(color: AppColors.primary)),
                  child: const Text('Contact Support'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _aboutRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, color: AppColors.textSecondary)),
        Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textPrimary)),
      ],
    );
  }
}
