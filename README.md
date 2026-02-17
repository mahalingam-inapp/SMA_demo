# SMA Energy App (Flutter)

Flutter port of the SMA Energy App Sitemap (React mockup).

**Location:** `SMA/SMA Flutter/` (inside the SMA folder).  
**Migration strategy:** `../FLUTTER_MIGRATION_STRATEGY.md` (same `SMA/` folder).

## Setup

1. Install [Flutter](https://flutter.dev/docs/get-started/install).
2. From this directory run:
   - `flutter pub get`
   - If Android/iOS folders are missing, run `flutter create . --project-name sma_energy_app` to add platform files (this preserves `lib/`).
3. Run: `flutter run` (or open in IDE and run).

## Stack

- **State:** Riverpod
- **Routing:** GoRouter
- **Charts:** fl_chart
- **Theme:** Material 3 with SMA colors (blue/orange)

## Dart / SDK

Targets **Dart 2.19.2** (SDK `>=2.19.2 <3.0.0`). Uses `Color.withOpacity()` instead of `Color.withValues(alpha:)`, and package versions compatible with Dart 2.x.
