import 'package:bam_wallet/core/notifications/presentation/providers/notification_providers.dart';
import 'package:bam_wallet/features/login/presentation/providers/auth_providers.dart';
import 'package:bam_wallet/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class MainShell extends ConsumerWidget {
  final Widget child;

  const MainShell({super.key, required this.child});

  int _getCurrentIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    if (location.startsWith('/settings')) return 1;
    return 0; // home por defecto
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Inicializar FCM cuando el usuario está autenticado
    final user = ref.watch(authStateProvider).whenOrNull(
          authenticated: (user) => user,
        );
    if (user != null) {
      ref.watch(fcmTokenProvider(user.id));
    }

    ref.listen(foregroundNotificationProvider, (_, next) {
      next.whenData((n) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${n.title}: ${n.body}')),
        );
      });
    });

    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _getCurrentIndex(context),
        onDestinationSelected: (index) {
          switch (index) {
            case 0:
              context.go('/home');
            case 1:
              context.go('/settings');
          }
        },
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home_outlined),
            selectedIcon: const Icon(Icons.home),
            label: l10n.nav_home,
          ),
          NavigationDestination(
            icon: const Icon(Icons.settings_outlined),
            selectedIcon: const Icon(Icons.settings),
            label: l10n.nav_settings,
          ),
        ],
      ),
    );
  }
}
