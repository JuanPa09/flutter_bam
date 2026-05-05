import 'package:bam_wallet/core/environment/env.dart';
import 'package:bam_wallet/core/service_locator/service_locator.dart';
import 'package:bam_wallet/features/application/core/router/app_router.dart';
import 'package:bam_wallet/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runProject();
}

void runProject() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Env.initialize();
  await ServiceLocator().setup('real'); //options: mock, real
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ServiceLocator().loginProvider,
      child: MaterialApp.router(
        title: 'Bam Wallet',
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
