import 'package:bam_wallet/features/application/features/home/presentation/screens/home_screen.dart';
import 'package:bam_wallet/features/application/features/home/presentation/screens/transfer_history_screen.dart';
import 'package:bam_wallet/features/application/features/home/presentation/screens/transfer_screen.dart';
import 'package:bam_wallet/features/application/features/settings/presentation/screens/settings_screen.dart';
import 'package:bam_wallet/features/application/features/shell/presentation/screens/main_shell.dart';
import 'package:bam_wallet/features/login/presentation/providers/login_provider.dart';
import 'package:bam_wallet/features/login/presentation/views/login_view.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class AppRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final _shellNavigatorKey = GlobalKey<NavigatorState>();

  static final router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/login',
    redirect: (context, state) {
      final loginProvider = context.read<LoginProvider>();
      final isLoggedIn = loginProvider.isLoggedIn;
      final location = state.uri.toString();
      if (isLoggedIn && (location == '/login' || location == '/')) {
        return '/home';
      }
      if (!isLoggedIn && location != '/login') {
        return '/login';
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        pageBuilder: (context, state) => const NoTransitionPage(
          child: LoginView(),
        ),
      ),
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) {
          return MainShell(child: child);
        },
        routes: [
          GoRoute(
            path: '/home',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: HomeScreen(),
            ),
          ),
          GoRoute(
            path: '/settings',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: SettingsScreen(),
            ),
          ),
        ],
      ),
      GoRoute(
        path: '/transfer',
        pageBuilder: (context, state) => const NoTransitionPage(
          child: TransferScreen(),
        ),
      ),
      GoRoute(
        path: '/transfer-history',
        pageBuilder: (context, state) => const NoTransitionPage(
          child: TransferHistoryScreen(),
        ),
      ),
    ],
  );
}