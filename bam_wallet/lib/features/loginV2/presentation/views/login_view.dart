import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:bam_wallet/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:bam_wallet/features/loginV2/presentation/state/login_provider.dart';
import 'package:bam_wallet/features/login/presentation/widgets/email_widget.dart';
import 'package:bam_wallet/features/login/presentation/widgets/password_widget.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late GlobalKey<FormState> _formKey;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _formKey = GlobalKey<FormState>();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // String? _validateEmail(String? value) {
  //   if (value == null || value.isEmpty) {
  //     return AppLocalizations.of(context)!.email_required;
  //   }
  //   final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
  //   if (!emailRegex.hasMatch(value)) {
  //     return AppLocalizations.of(context)!.invalid_mail;
  //   }
  //   return null;
  // }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return AppLocalizations.of(context)!.password_required;
    }
    if (value.length < 6) {
      return AppLocalizations.of(context)!.invalid_password;
    }
    return null;
  }

  void _handleLogin() {
    if (_formKey.currentState?.validate() ?? false) {
      final loginProvider = context.read<LoginProvider>();
      loginProvider.login(
        _emailController.text.trim(),
        _passwordController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.loginScreenName),
        centerTitle: true,
      ),
      body: Consumer<LoginProvider>(
        builder: (context, loginProvider, _) {
          if (loginProvider.isLoggedIn) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (context.mounted) context.go('/home');
            });
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 40),
                  Text(
                    AppLocalizations.of(context)!.appTitle,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    AppLocalizations.of(context)!.login_instructions,
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 48),
                  EmailWidget(
                    controller: _emailController
                  ),
                  const SizedBox(height: 16),
                  PasswordWidget(
                    controller: _passwordController,
                    validator: _validatePassword,
                  ),
                  const SizedBox(height: 24),
                  if (loginProvider.errorMessage != null)
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red.shade100,
                        border: Border.all(color: Colors.red),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        loginProvider.errorMessage! == 'Exception: 401'
                            ? AppLocalizations.of(context)!.error_401
                            : loginProvider.errorMessage! == 'error_invalid_credentials'
                                ? AppLocalizations.of(context)!.error_invalid_credentials
                                : loginProvider.errorMessage!,
                        style: TextStyle(color: Colors.red.shade900),
                      ),
                    ),
                  if (loginProvider.errorMessage != null)
                    const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: loginProvider.isLoading ? null : _handleLogin,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: loginProvider.isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(AppLocalizations.of(context)!.btn_login),
                  ),
                  const SizedBox(height: 24),
                  Center(
                    child: Text(
                      'Para probar: \n\n emilys \n emilyspass',
                      style: Theme.of(context).textTheme.bodySmall,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
