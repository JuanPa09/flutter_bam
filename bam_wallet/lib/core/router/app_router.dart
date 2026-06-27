import 'package:bam_wallet/features/home/presentation/screens/home_screen.dart';
import 'package:bam_wallet/features/home/presentation/screens/transfer_history_screen.dart';
import 'package:bam_wallet/features/home/presentation/screens/transfer_screen.dart';
import 'package:bam_wallet/features/settings/presentation/screens/settings_screen.dart';
import 'package:bam_wallet/features/shell/presentation/screens/main_shell.dart';
import 'package:bam_wallet/features/login/presentation/views/login_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:bam_wallet/features/login/presentation/providers/auth_providers.dart';

class AppRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final _shellNavigatorKey = GlobalKey<NavigatorState>();

  static final router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/login',
    routes: [
      GoRoute(
        path: '/login',
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: LoginView()),
      ),
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) {
          return MainShell(child: child);
        },
        routes: [
          GoRoute(
            path: '/home',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: HomeScreen()),
          ),
          GoRoute(
            path: '/settings',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: SettingsScreen()),
          ),
        ],
      ),
      GoRoute(
        path: '/transfer',
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: TransferScreen()),
      ),
      GoRoute(
        path: '/transfer-history',
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: TransferHistoryScreen()),
      ),
    ],
  );
}

/// Wrapper para manejar la navegación basada en el estado de autenticación
class AuthRouterListener extends ConsumerWidget {
  final Widget child;

  const AuthRouterListener({required this.child, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Listener para cambios de estado de autenticación
    ref.listen(authStateProvider, (previous, next) {
      next.whenOrNull(
        authenticated: (user) {
          // Redirigir a home cuando se autentica
          if (context.mounted) {
            final currentLocation = GoRouterState.of(context).uri.toString();
            if (currentLocation == '/login') {
              AppRouter.router.go('/home');
            }
          }
        },
        unauthenticated: () {
          // Redirigir a login cuando se desautentica
          if (context.mounted) {
            final currentLocation = GoRouterState.of(context).uri.toString();
            if (currentLocation != '/login') {
              AppRouter.router.go('/login');
            }
          }
        },
      );
    });

    return child;
  }
}
