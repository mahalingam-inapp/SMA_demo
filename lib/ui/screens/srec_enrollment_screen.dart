import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../data/models/device.dart';
import '../../providers/energy_provider.dart';

class SRECEnrollmentScreen extends ConsumerStatefulWidget {
  const SRECEnrollmentScreen({super.key});

  @override
  ConsumerState<SRECEnrollmentScreen> createState() => _SRECEnrollmentScreenState();
}

class _SRECEnrollmentScreenState extends ConsumerState<SRECEnrollmentScreen> {
  final _formKey = GlobalKey<FormState>();
  String _ownerName = '';
  String _utility = '';
  String _bankAccount = '';

  String get _systemId {
    final site = ref.read(energyProvider).currentSite;
    return 'SYS-${site.id.toUpperCase().replaceAll("-", "")}';
  }

  String get _deviceId {
    final devices = ref.read(energyProvider).devices;
    final invList = devices.where((d) => d.type == DeviceType.inverter).toList();
    return invList.isEmpty ? 'INV-2024-001234' : invList.first.serial;
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState!.save();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('SREC Enrollment submitted successfully!')),
      );
      context.go('/programs');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios, size: 20), onPressed: () => context.pop()),
        title: const Text('SREC Enrollment', style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600)),
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
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Color(0xFFF97316), Color(0xFFEA580C)],
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.emoji_events, size: 32, color: Colors.white),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('SREC Program', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                              const SizedBox(height: 8),
                              Text(
                                'Earn certificates for every megawatt-hour (MWh) of solar electricity you generate',
                                style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.chartSolar.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Program Benefits:', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.chartSolar.withOpacity(0.9))),
                          const SizedBox(height: 8),
                          _benefit('Earn \$50-200 per SREC'),
                          _benefit('One SREC per MWh produced'),
                          _benefit('Quarterly payouts'),
                        ],
                      ),
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
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Enrollment Form', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                      const SizedBox(height: 16),
                      _readOnlyField('System ID (Pre-filled)', _systemId),
                      const SizedBox(height: 12),
                      _readOnlyField('Device ID (Pre-filled)', _deviceId),
                      const SizedBox(height: 12),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Owner Name *',
                          hintText: 'John Doe',
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: AppColors.surface,
                        ),
                        validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
                        onSaved: (v) => _ownerName = v ?? '',
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Utility Company *',
                          hintText: 'e.g., Pacific Gas & Electric',
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: AppColors.surface,
                        ),
                        validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
                        onSaved: (v) => _utility = v ?? '',
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Bank Account (for payouts) *',
                          hintText: 'Account ending in XXXX',
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: AppColors.surface,
                        ),
                        validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
                        onSaved: (v) => _bankAccount = v ?? '',
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _submit,
                          style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                          child: const Text('Submit Enrollment'),
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () => context.pop(),
                          child: const Text('Cancel'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.backgroundBottom,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'By enrolling, you agree to the SREC program terms and conditions. Your system data will be shared with the SREC aggregator for certificate generation and verification.',
                style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _benefit(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(Icons.check_circle, size: 18, color: AppColors.chartSolar),
          const SizedBox(width: 8),
          Text(text, style: const TextStyle(fontSize: 13, color: AppColors.textPrimary)),
        ],
      ),
    );
  }

  Widget _readOnlyField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.textSecondary)),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.backgroundBottom,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.border),
          ),
          child: Text(value, style: const TextStyle(color: AppColors.textPrimary)),
        ),
      ],
    );
  }
}
