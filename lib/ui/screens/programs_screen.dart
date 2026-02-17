import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';

class ProgramsScreen extends ConsumerWidget {
  const ProgramsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios), onPressed: () => context.pop()),
        title: const Text('Programs', style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600)),
        backgroundColor: AppColors.surface,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ListTile(
            title: const Text('SREC Enrollment'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/programs/srec'),
          ),
          ListTile(
            title: const Text('VPP Enrollment'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/programs/vpp'),
          ),
        ],
      ),
    );
  }
}
