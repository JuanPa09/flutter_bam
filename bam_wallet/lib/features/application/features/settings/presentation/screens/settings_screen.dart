import 'package:bam_wallet/features/login/presentation/providers/login_provider.dart';
import 'package:bam_wallet/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:local_auth/local_auth.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _biometricPreferenceKey = 'settings_biometric_enabled';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  PackageInfo? _packageInfo;
  bool _biometricEnabled = false;
  bool _canCheckBiometrics = false;
  bool _biometricLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadPackageInfo();
    _loadBiometricState();
  }

  Future<void> _loadPackageInfo() async {
    try {
      final info = await PackageInfo.fromPlatform();
      if (mounted) setState(() => _packageInfo = info);
    } on MissingPluginException {
      // package_info_plus not implemented on this platform (e.g. web), use fallback
      if (mounted) setState(() {});
    }
  }

  Future<void> _loadBiometricState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final auth = LocalAuthentication();
      final canCheck = await auth.canCheckBiometrics;
      final enabled = prefs.getBool(_biometricPreferenceKey) ?? false;
      if (mounted) {
        setState(() {
          _canCheckBiometrics = canCheck;
          _biometricEnabled = enabled;
          _biometricLoaded = true;
        });
      }
    } on MissingPluginException {
      // shared_preferences or local_auth not implemented on this platform (e.g. web)
      if (mounted) {
        setState(() {
          _canCheckBiometrics = false;
          _biometricLoaded = true;
        });
      }
    }
  }

  Future<void> _onBiometricToggle(bool value) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_biometricPreferenceKey, value);
    } on MissingPluginException {
      // shared_preferences not available on this platform, keep in-memory only
    }
    if (mounted) setState(() => _biometricEnabled = value);
  }

  void _showComingSoon(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.settings_coming_soon)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final user = context.watch<LoginProvider>().user;
    final name = user?.name ?? 'User';
    final username = user?.email ?? '';

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: _ProfileHeader(name: name, username: username),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
                child: Text(
                  l10n.settings_section_account,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: _SectionCard(
                children: [
                  ListTile(
                    title: Text(l10n.settings_account_update_info),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => _showComingSoon(context),
                  ),
                ],
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
                child: Text(
                  l10n.settings_section_security,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: _SectionCard(
                children: [
                  ListTile(
                    title: Text(l10n.settings_security_change_password),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => _showComingSoon(context),
                  ),
                  if (_biometricLoaded && _canCheckBiometrics)
                    ListTile(
                      title: Text(l10n.settings_security_biometric),
                      trailing: Switch(
                        value: _biometricEnabled,
                        onChanged: _onBiometricToggle,
                      ),
                    ),
                  ListTile(
                    title: Text(l10n.settings_security_two_factor),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => _showComingSoon(context),
                  ),
                ],
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
                child: Text(
                  l10n.settings_section_preferences,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: _SectionCard(
                children: [
                  ListTile(
                    title: Text(l10n.settings_preferences_notifications),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => _showComingSoon(context),
                  ),
                  ListTile(
                    title: Text(l10n.settings_preferences_privacy_policy),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => _showComingSoon(context),
                  ),
                  ListTile(
                    title: Text(l10n.settings_preferences_support),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => _showComingSoon(context),
                  ),
                ],
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 32)),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: OutlinedButton.icon(
                  onPressed: () async {
                    await context.read<LoginProvider>().logout();
                    if (context.mounted) context.go('/login');
                  },
                  icon: const Icon(Icons.logout),
                  label: Text(l10n.btn_logout),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.error,
                    side: BorderSide(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(top: 16, bottom: 24),
                child: Center(
                  child: Text(
                    '${l10n.settings_version} ${_packageInfo?.version ?? '1.0.0'}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  final String name;
  final String username;

  const _ProfileHeader({required this.name, required this.username});

  @override
  Widget build(BuildContext context) {
    final initial = name.isNotEmpty ? name.substring(0, 1).toUpperCase() : '?';
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          CircleAvatar(
            radius: 32,
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            child: Text(
              initial,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                if (username.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    username,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final List<Widget> children;

  const _SectionCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: children,
        ),
      ),
    );
  }
}
