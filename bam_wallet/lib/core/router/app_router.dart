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

/// Lista de rutas públicas (sin autenticación requerida)
const List<String> _publicRoutes = ['/login'];

/// Lista de rutas protegidas (requieren autenticación)
const List<String> _protectedRoutes = [
  '/home',
  '/settings',
  '/transfer',
  '/transfer-history',
];

class _AuthRouterNotifier extends ChangeNotifier {
  final Ref _ref;

  _AuthRouterNotifier(this._ref) {
    // Escuchar cambios en el estado de autenticación
    _ref.listen(authStateProvider, (previous, next) {
      notifyListeners();
    });
  }

  bool get isAuthenticated {
    final authState = _ref.read(authStateProvider);
    return authState.whenOrNull(authenticated: (user) => true) ?? false;
  }
}

class AppRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final _shellNavigatorKey = GlobalKey<NavigatorState>();

  static late final GoRouter _router;
  static late final _AuthRouterNotifier _authNotifier;

  /// Inicializar el router con acceso a Riverpod
  static void initialize(Ref ref) {
    _authNotifier = _AuthRouterNotifier(ref);
    _router = _buildRouter();
  }

  static GoRouter get router => _router;

  /// Construir el router con lógica de redirección
  static GoRouter _buildRouter() {
    return GoRouter(
      navigatorKey: _rootNavigatorKey,
      initialLocation: '/login',
      refreshListenable: _authNotifier,
      redirect: (context, state) {
        final isAuthenticated = _authNotifier.isAuthenticated;
        final isPublicRoute = _publicRoutes.contains(state.uri.path);
        final isProtectedRoute = _protectedRoutes.contains(state.uri.path);

        // Si está autenticado y va a /login, ir a /home
        if (isAuthenticated && isPublicRoute) {
          return '/home';
        }

        // Si NO está autenticado y va a ruta protegida, ir a /login
        if (!isAuthenticated && isProtectedRoute) {
          return '/login';
        }

        // Sin cambios de ruta
        return null;
      },
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
}
