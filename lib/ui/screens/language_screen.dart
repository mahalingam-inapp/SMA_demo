import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';

class LanguageScreen extends ConsumerStatefulWidget {
  const LanguageScreen({super.key});

  @override
  ConsumerState<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends ConsumerState<LanguageScreen> {
  String _selectedCode = 'en';
  bool _saved = false;

  static const _languages = [
    {'code': 'en', 'name': 'English', 'nativeName': 'English'},
    {'code': 'es', 'name': 'Spanish', 'nativeName': 'Español'},
    {'code': 'fr', 'name': 'French', 'nativeName': 'Français'},
    {'code': 'de', 'name': 'German', 'nativeName': 'Deutsch'},
    {'code': 'it', 'name': 'Italian', 'nativeName': 'Italiano'},
    {'code': 'pt', 'name': 'Portuguese', 'nativeName': 'Português'},
  ];

  void _save() {
    setState(() {
      _saved = true;
    });
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _saved = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios, size: 20), onPressed: () => context.pop()),
        title: const Text('Language', style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600)),
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
                    const Text('Select Language', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                    const SizedBox(height: 16),
                    ..._languages.map((lang) {
                      final code = lang['code'] as String;
                      final selected = _selectedCode == code;
                      return Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () => setState(() => _selectedCode = code),
                          borderRadius: BorderRadius.circular(8),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: Row(
                              children: [
                                Radio<String>(
                                  value: code,
                                  groupValue: _selectedCode,
                                  onChanged: (v) => setState(() => _selectedCode = v ?? code),
                                  activeColor: AppColors.primary,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(lang['name'] as String, style: const TextStyle(fontWeight: FontWeight.w500, color: AppColors.textPrimary)),
                                      Text(lang['nativeName'] as String, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                                    ],
                                  ),
                                ),
                                if (selected) const Icon(Icons.check, color: AppColors.primary, size: 22),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _saved ? null : _save,
                        style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                        icon: Icon(_saved ? Icons.check : Icons.save, size: 20),
                        label: Text(_saved ? 'Saved!' : 'Save Changes'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.primary.withOpacity(0.3)),
              ),
              child: const Text(
                'Note: Changing the language will update all text in the app. Some content may require an app restart to fully update.',
                style: TextStyle(fontSize: 13, color: AppColors.textPrimary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
