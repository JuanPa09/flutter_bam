import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:bam_wallet/l10n/app_localizations.dart';
import 'package:bam_wallet/features/login/presentation/providers/auth_providers.dart';
import 'package:bam_wallet/features/login/presentation/widgets/email_widget.dart';
import 'package:bam_wallet/features/login/presentation/widgets/password_widget.dart';

class LoginView extends ConsumerStatefulWidget {
  const LoginView({super.key});

  @override
  ConsumerState<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends ConsumerState<LoginView> {
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
      ref
          .read(authStateProvider.notifier)
          .login(_emailController.text.trim(), _passwordController.text);
    }
  }

  /// Translates error keys to localized strings
  String _getLocalizedErrorMessage(String errorKey) {
    final l10n = AppLocalizations.of(context)!;
    switch (errorKey) {
      // Firebase errors
      case 'error_firebase_invalid_credentials':
        return l10n.error_firebase_invalid_credentials;
      case 'error_firebase_user_not_found':
        return l10n.error_firebase_user_not_found;
      case 'error_firebase_wrong_password':
        return l10n.error_firebase_wrong_password;
      // Legacy errors
      case 'error_invalid_credentials_400':
        return l10n.error_invalid_credentials_400;
      case 'error_unauthorized_401':
        return l10n.error_unauthorized_401;
      case 'error_forbidden_403':
        return l10n.error_forbidden_403;
      case 'error_user_not_found_404':
        return l10n.error_user_not_found_404;
      case 'error_server_500':
        return l10n.error_server_500;
      case 'error_connection_timeout':
        return l10n.error_connection_timeout;
      case 'error_receive_timeout':
        return l10n.error_receive_timeout;
      case 'error_send_timeout':
        return l10n.error_send_timeout;
      case 'error_request_cancelled':
        return l10n.error_request_cancelled;
      case 'error_network_unknown':
        return l10n.error_network_unknown;
      case 'invalid_mail':
        return l10n.invalid_mail;
      case 'error_unexpected':
      default:
        return l10n.error_unexpected;
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.loginScreenName),
        centerTitle: true,
      ),
      body: authState.when(
        authenticated: (_) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (context.mounted) context.go('/home');
          });
          return const Center(child: CircularProgressIndicator());
        },
        loading: () => SingleChildScrollView(
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
                EmailWidget(controller: _emailController),
                const SizedBox(height: 16),
                PasswordWidget(
                  controller: _passwordController,
                  validator: _validatePassword,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _handleLogin,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
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
        ),
        initial: () => const Center(child: SizedBox.shrink()),
        unauthenticated: () => SingleChildScrollView(
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
                EmailWidget(controller: _emailController),
                const SizedBox(height: 16),
                PasswordWidget(
                  controller: _passwordController,
                  validator: _validatePassword,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _handleLogin,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(AppLocalizations.of(context)!.btn_login),
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
        ),
        error: (message) => SingleChildScrollView(
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
                EmailWidget(controller: _emailController),
                const SizedBox(height: 16),
                PasswordWidget(
                  controller: _passwordController,
                  validator: _validatePassword,
                ),
                const SizedBox(height: 16),
                // Error message - small and compact
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.shade100,
                    border: Border.all(color: Colors.red.shade400),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _getLocalizedErrorMessage(message),
                    style: TextStyle(color: Colors.red.shade900, fontSize: 13),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _handleLogin,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(AppLocalizations.of(context)!.btn_login),
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
        ),
      ),
    );
  }
}
