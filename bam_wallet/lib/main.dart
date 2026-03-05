import 'package:bam_wallet/core/environment/env.dart';
import 'package:bam_wallet/core/service_locator/service_locator.dart';
import 'package:bam_wallet/features/login/presentation/views/login_view.dart';
import 'package:bam_wallet/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void runProject() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Env.initialize();
  await ServiceLocator().setup('dev'); //definir si se usa mock o no
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ServiceLocator().loginProvider,
      child: MaterialApp(
        title: 'Bam Wallet',
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: const LoginView(),
      ),
    );
  }
}
