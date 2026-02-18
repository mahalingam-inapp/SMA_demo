import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  bool _editing = false;
  String _name = 'John Doe';
  String _email = 'john.doe@example.com';
  String _phone = '(555) 123-4567';

  void _save() {
    setState(() => _editing = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios, size: 20), onPressed: () => context.pop()),
        title: const Text('Profile', style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600)),
        backgroundColor: AppColors.surface,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Material(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        CircleAvatar(
                          radius: 48,
                          backgroundColor: AppColors.primary.withOpacity(0.15),
                          child: const Icon(Icons.person, size: 48, color: AppColors.primary),
                        ),
                        Material(
                          color: AppColors.primary,
                          shape: const CircleBorder(),
                          child: InkWell(
                            onTap: () {},
                            customBorder: const CircleBorder(),
                            child: const Padding(
                              padding: EdgeInsets.all(10),
                              child: Icon(Icons.camera_alt, size: 20, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(_name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                    const SizedBox(height: 4),
                    Text(_email, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Personal Information', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                        if (!_editing)
                          TextButton(
                            onPressed: () => setState(() => _editing = true),
                            child: const Text('Edit'),
                          ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _field('Full Name', Icons.person_outline, _name, (v) => setState(() => _name = v), _editing),
                    const SizedBox(height: 12),
                    _field('Email', Icons.email_outlined, _email, (v) => setState(() => _email = v), _editing),
                    const SizedBox(height: 12),
                    _field('Phone', Icons.phone_outlined, _phone, (v) => setState(() => _phone = v), _editing),
                    if (_editing) ...[
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: _save,
                              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                              child: const Text('Save Changes'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => setState(() => _editing = false),
                              child: const Text('Cancel'),
                            ),
                          ),
                        ],
                      ),
                    ],
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
                    const Text('Security', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.lock_outline, size: 20),
                        label: const Text('Change Password'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _field(String label, IconData icon, String value, ValueChanged<String> onChanged, bool enabled) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 18, color: AppColors.textSecondary),
            const SizedBox(width: 8),
            Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.textSecondary)),
          ],
        ),
        const SizedBox(height: 6),
        TextFormField(
          initialValue: value,
          onChanged: onChanged,
          enabled: enabled,
          decoration: InputDecoration(
            filled: true,
            fillColor: enabled ? null : AppColors.backgroundBottom,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          ),
        ),
      ],
    );
  }
}
