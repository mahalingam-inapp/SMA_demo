import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod/riverpod.dart';

import '../providers/energy_provider.dart';
import '../ui/layouts/app_layout.dart';
import '../ui/screens/about_screen.dart';
import '../ui/screens/alert_details_screen.dart';
import '../ui/screens/alerts_screen.dart';
import '../ui/screens/dashboard_screen.dart';
import '../ui/screens/device_details_screen.dart';
import '../ui/screens/devices_screen.dart';
import '../ui/screens/energy_flow_screen.dart';
import '../ui/screens/forecast_screen.dart';
import '../ui/screens/hems_config_screen.dart';
import '../ui/screens/hems_screen.dart';
import '../ui/screens/history_screen.dart';
import '../ui/screens/language_screen.dart';
import '../ui/screens/login_screen.dart';
import '../ui/screens/notifications_screen.dart';
import '../ui/screens/profile_screen.dart';
import '../ui/screens/programs_screen.dart';
import '../ui/screens/signup_screen.dart';
import '../ui/screens/site_details_screen.dart';
import '../ui/screens/site_management_screen.dart';
import '../ui/screens/srec_enrollment_screen.dart';
import '../ui/screens/splash_screen.dart';
import '../ui/screens/vpp_enrollment_screen.dart';
import '../ui/screens/settings_screen.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

GoRouter createAppRouter(Ref ref) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    redirect: (BuildContext context, GoRouterState state) {
      final energy = ProviderScope.containerOf(context).read(energyProvider);
      final isAuth = energy.isAuthenticated;
      final loc = state.uri.path;

      if (loc == '/settings/pairing') return '/devices';
      if (loc == '/settings/units') return '/settings';
      if (loc == '/' && isAuth) return '/dashboard';
      final isAuthRoute = loc.startsWith('/dashboard') ||
          loc.startsWith('/history') ||
          loc.startsWith('/devices') ||
          loc.startsWith('/alerts') ||
          loc.startsWith('/energy-flow') ||
          loc.startsWith('/forecast') ||
          loc.startsWith('/programs') ||
          loc.startsWith('/settings') ||
          loc.startsWith('/hems');
      if (isAuthRoute && !isAuth) return '/';
      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        builder: (_, __) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (_, __) => const LoginScreen(),
      ),
      GoRoute(
        path: '/signup',
        builder: (_, __) => const SignupScreen(),
      ),
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) => AppLayout(child: child),
        routes: [
          GoRoute(
            path: '/dashboard',
            pageBuilder: (_, state) => NoTransitionPage(child: const DashboardScreen()),
          ),
          GoRoute(
            path: '/history',
            pageBuilder: (_, state) => NoTransitionPage(child: const HistoryScreen()),
          ),
          GoRoute(
            path: '/devices',
            pageBuilder: (_, state) => NoTransitionPage(child: const DevicesScreen()),
          ),
          GoRoute(
            path: '/alerts',
            pageBuilder: (_, state) => NoTransitionPage(child: const AlertsScreen()),
          ),
        ],
      ),
      GoRoute(
        path: '/energy-flow',
        builder: (_, __) => const EnergyFlowScreen(),
      ),
      GoRoute(
        path: '/forecast',
        builder: (_, __) => const ForecastScreen(),
      ),
      GoRoute(
        path: '/devices/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return DeviceDetailsScreen(deviceId: id);
        },
      ),
      GoRoute(
        path: '/alerts/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return AlertDetailsScreen(alertId: id);
        },
      ),
      GoRoute(
        path: '/programs',
        builder: (_, __) => const ProgramsScreen(),
      ),
      GoRoute(
        path: '/programs/srec',
        builder: (_, __) => const SRECEnrollmentScreen(),
      ),
      GoRoute(
        path: '/programs/vpp',
        builder: (_, __) => const VPPEnrollmentScreen(),
      ),
      GoRoute(
        path: '/settings',
        builder: (_, __) => const SettingsScreen(),
      ),
      GoRoute(
        path: '/settings/profile',
        builder: (_, __) => const ProfileScreen(),
      ),
      GoRoute(
        path: '/settings/sites',
        builder: (_, __) => const SiteManagementScreen(),
      ),
      GoRoute(
        path: '/settings/sites/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return SiteDetailsScreen(siteId: id);
        },
      ),
      GoRoute(
        path: '/settings/notifications',
        builder: (_, __) => const NotificationsScreen(),
      ),
      GoRoute(
        path: '/settings/language',
        builder: (_, __) => const LanguageScreen(),
      ),
      GoRoute(
        path: '/settings/about',
        builder: (_, __) => const AboutScreen(),
      ),
      GoRoute(
        path: '/hems',
        builder: (_, __) => const HEMSScreen(),
      ),
      GoRoute(
        path: '/hems/config',
        builder: (_, __) => const HEMSConfigScreen(),
      ),
    ],
  );
}

final goRouterProvider = Provider<GoRouter>((ref) {
  return createAppRouter(ref);
});

class NoTransitionPage extends CustomTransitionPage<void> {
  NoTransitionPage({required Widget child})
      : super(
          child: child,
          transitionsBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation, Widget child) {
            return child;
          },
        );
}
