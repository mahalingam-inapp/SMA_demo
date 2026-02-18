import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';

class VPPEnrollmentScreen extends ConsumerStatefulWidget {
  const VPPEnrollmentScreen({super.key});

  @override
  ConsumerState<VPPEnrollmentScreen> createState() => _VPPEnrollmentScreenState();
}

class _VPPEnrollmentScreenState extends ConsumerState<VPPEnrollmentScreen> {
  bool _enrolled = false;
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _email = '';
  String _phone = '';

  static const _upcomingEvents = [
    {'date': 'Feb 20, 2026', 'time': '2:00 PM - 6:00 PM', 'type': 'Peak Demand Event'},
    {'date': 'Feb 25, 2026', 'time': '5:00 PM - 9:00 PM', 'type': 'Grid Support Event'},
  ];

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState!.save();
      setState(() => _enrolled = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios, size: 20), onPressed: () => context.pop()),
        title: const Text('Virtual Power Plant', style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600)),
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
                              colors: [Color(0xFF3B82F6), Color(0xFF2563EB)],
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.bolt, size: 32, color: Colors.white),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Virtual Power Plant', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                              const SizedBox(height: 8),
                              Text(
                                'Help stabilize the grid during peak demand and earn rewards for your participation',
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
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Program Benefits:', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.primary)),
                          const SizedBox(height: 8),
                          _benefit('\$100-300 annual earnings'),
                          _benefit('Support grid stability'),
                          _benefit('Event-based participation'),
                          _benefit('Automatic battery management'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (!_enrolled) ...[
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
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Full Name *',
                            hintText: 'John Doe',
                            border: OutlineInputBorder(),
                            filled: true,
                            fillColor: AppColors.surface,
                          ),
                          validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
                          onSaved: (v) => _name = v ?? '',
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Email Address *',
                            hintText: 'john@example.com',
                            border: OutlineInputBorder(),
                            filled: true,
                            fillColor: AppColors.surface,
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
                          onSaved: (v) => _email = v ?? '',
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Phone Number *',
                            hintText: '(555) 123-4567',
                            border: OutlineInputBorder(),
                            filled: true,
                            fillColor: AppColors.surface,
                          ),
                          keyboardType: TextInputType.phone,
                          validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
                          onSaved: (v) => _phone = v ?? '',
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.backgroundBottom,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text('How it works:', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                              const SizedBox(height: 8),
                              const Text('• We\'ll notify you of upcoming VPP events', style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                              const Text('• Your battery will automatically discharge during events', style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                              const Text('• You earn rewards based on energy contributed', style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                              const Text('• Opt out anytime with no penalties', style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _submit,
                            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                            child: const Text('Enroll in VPP'),
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
            ] else ...[
              Material(
                color: AppColors.success.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.check_circle, size: 32, color: AppColors.success),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Text(
                              'Enrollment Successful!',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "You're now part of the Virtual Power Plant program. You'll receive notifications about upcoming events.",
                        style: TextStyle(color: AppColors.textPrimary),
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
                      Row(
                        children: [
                          const Icon(Icons.calendar_today, size: 20, color: AppColors.primary),
                          const SizedBox(width: 8),
                          const Text('Upcoming Events', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      ..._upcomingEvents.map((e) => Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AppColors.backgroundBottom,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(e['type']!, style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                                  const SizedBox(height: 4),
                                  Text('${e['date']} • ${e['time']}', style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                                ],
                              ),
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
                      Row(
                        children: [
                          const Icon(Icons.attach_money, size: 20, color: AppColors.success),
                          const SizedBox(width: 8),
                          const Text('Earnings', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('This Month', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                                const SizedBox(height: 4),
                                const Text('\$24', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.success)),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Total Earned', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                                const SizedBox(height: 4),
                                const Text('\$156', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                              ],
                            ),
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
                      const Text('Controls', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () {},
                          child: const Text('Pause Participation'),
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(foregroundColor: AppColors.destructive),
                          child: const Text('Unenroll from Program'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
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
          const Icon(Icons.check_circle, size: 18, color: AppColors.primary),
          const SizedBox(width: 8),
          Text(text, style: const TextStyle(fontSize: 13, color: AppColors.textPrimary)),
        ],
      ),
    );
  }
}
