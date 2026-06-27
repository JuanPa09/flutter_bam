import 'package:bam_wallet/core/utils/currency_format.dart';
import 'package:bam_wallet/features/home/data/models/bank_account.dart';
import 'package:bam_wallet/features/home/presentation/providers/home_providers.dart';
import 'package:bam_wallet/features/login/presentation/providers/auth_providers.dart';
import 'package:bam_wallet/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionUser = ref.watch(userProvider);
    final homeState = ref.watch(homeStateProvider);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: SafeArea(
        child: homeState.when(
          initial: () => const SizedBox.shrink(),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (message) => Center(child: Text(message)),
          loaded: (accounts, _) => CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: _Header(
                  userName: sessionUser?.fullName ?? '',
                  photoUrl: null,
                  greeting: l10n.home_good_morning,
                ),
              ),
              SliverToBoxAdapter(
                child: _BalanceTotal(
                  amount: accounts.fold<double>(0, (sum, a) => sum + a.balance),
                  label: l10n.home_total_balance,
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
                  child: Text(
                    l10n.home_my_accounts,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 6,
                    ),
                    child: _AccountCard(
                      account: accounts[index],
                      transferLabel: l10n.home_transfer,
                      historyLabel: l10n.home_view_history,
                      onTransfer: () => context.push('/transfer'),
                      onHistory: () => context.push('/transfer-history'),
                    ),
                  ),
                  childCount: accounts.length,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final String userName;
  final String? photoUrl;
  final String greeting;

  const _Header({
    required this.userName,
    this.photoUrl,
    required this.greeting,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            backgroundImage: photoUrl != null && photoUrl!.isNotEmpty
                ? NetworkImage(photoUrl!)
                : null,
            child: photoUrl == null || photoUrl!.isEmpty
                ? Text(
                    userName.isNotEmpty
                        ? userName.substring(0, 1).toUpperCase()
                        : '?',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  )
                : null,
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                greeting,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                userName,
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BalanceTotal extends StatelessWidget {
  final double amount;
  final String label;

  const _BalanceTotal({required this.amount, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            CurrencyFormat.formatGtq(amount),
            style: Theme.of(
              context,
            ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class _AccountCard extends StatelessWidget {
  final BankAccount account;
  final String transferLabel;
  final String historyLabel;
  final VoidCallback onTransfer;
  final VoidCallback onHistory;

  const _AccountCard({
    required this.account,
    required this.transferLabel,
    required this.historyLabel,
    required this.onTransfer,
    required this.onHistory,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              account.name,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                  CurrencyFormat.formatGtq(account.balance),
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(width: 8),
                Text(
                  account.currency,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    account.status,
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onTransfer,
                    icon: const Icon(Icons.send_outlined, size: 18),
                    label: Text(transferLabel),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onHistory,
                    icon: const Icon(Icons.history, size: 18),
                    label: Text(historyLabel),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
