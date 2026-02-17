import 'package:flutter/material.dart';

/// SMA design system colors (from theme.css / Figma).
abstract class AppColors {
  AppColors._();

  static const Color primary = Color(0xFF2563EB); // blue-600
  static const Color primaryDark = Color(0xFF1D4ED8); // blue-700
  static const Color accent = Color(0xFFF97316); // orange-500
  static const Color background = Color(0xFFF8FAFC); // slate-50
  static const Color backgroundBottom = Color(0xFFF1F5F9); // slate-100
  static const Color surface = Colors.white;
  static const Color textPrimary = Color(0xFF1E293B); // slate-800
  static const Color textSecondary = Color(0xFF64748B); // slate-600
  static const Color textMuted = Color(0xFF94A3B8); // slate-400
  static const Color border = Color(0xFFE2E8F0); // slate-200
  static const Color destructive = Color(0xFFDC2626); // red-600
  static const Color success = Color(0xFF10B981); // green-500
  static const Color chartSolar = Color(0xFFF97316); // orange-500
  static const Color chartConsumption = Color(0xFF3B82F6); // blue-500
  static const Color chartExport = Color(0xFF10B981); // green-500
}
