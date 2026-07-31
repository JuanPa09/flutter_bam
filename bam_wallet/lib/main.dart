import 'package:bam_wallet/core/environment/env.dart';
import 'package:bam_wallet/core/local_storage.dart';
import 'package:bam_wallet/core/service_locator/service_locator.dart';
import 'package:bam_wallet/core/locale/locale_provider.dart';
import 'package:bam_wallet/core/router/app_router.dart';
import 'package:bam_wallet/l10n/app_localizations.dart';
import 'package:bam_wallet/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Handler de mensajes en segundo plano — debe ser función top-level.
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Firebase ya está inicializado cuando este handler se invoca.
}

void main() async {
  await runProject();
}

Future<void> runProject() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Configure Firebase Messaging only for mobile platforms
  if (!kIsWeb) {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  await LocalStorage().init();
  await Env.initialize();
  await ServiceLocator().setup('real');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(child: _RouterScope());
  }
}

class _RouterScope extends ConsumerWidget {
  const _RouterScope();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.read(_routerProvider);

    final locale = ref.watch(localeProvider);

    return MaterialApp.router(
      title: 'Bam Wallet',
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      routerConfig: AppRouter.router,
    );
  }
}

/// Provider para inicializar el router una sola vez
final _routerProvider = Provider((ref) {
  AppRouter.initialize(ref);
  return null;
});
