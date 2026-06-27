import 'package:bam_wallet/core/environment/env.dart';
import 'package:bam_wallet/core/local_storage.dart';
import 'package:bam_wallet/core/service_locator/service_locator.dart';
import 'package:bam_wallet/core/locale/locale_provider.dart';
import 'package:bam_wallet/core/router/app_router.dart';
import 'package:bam_wallet/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runProject();
}

void runProject() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalStorage().init();
  await Env.initialize();
  await ServiceLocator().setup('real'); //options: mock, real
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);
    return AuthRouterListener(
      child: MaterialApp.router(
        title: 'Bam Wallet',
        locale: locale,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        routerConfig: AppRouter.router,
      ),
    );
  }
}
