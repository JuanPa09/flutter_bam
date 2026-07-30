import 'package:bam_wallet/core/utils/currency_format.dart';
import 'package:bam_wallet/features/home/domain/entities/transfer_entity.dart';
import 'package:bam_wallet/features/home/presentation/providers/transfer_history_providers.dart';
import 'package:bam_wallet/features/home/presentation/state/transfer_history_state.dart';
import 'package:bam_wallet/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class TransferHistoryScreen extends ConsumerStatefulWidget {
  const TransferHistoryScreen({super.key});

  @override
  ConsumerState<TransferHistoryScreen> createState() =>
      _TransferHistoryScreenState();
}

class _TransferHistoryScreenState extends ConsumerState<TransferHistoryScreen> {
  static final _dateFormat = DateFormat('d/MM/yyyy HH:mm');
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      ref.read(transferHistoryProvider.notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(transferHistoryProvider);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.transfer_history_title),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: state.when(
        initial: () => const Center(child: CircularProgressIndicator()),
        loading: () => const Center(child: CircularProgressIndicator()),
        loaded: (transfers, hasMore, isLoadingMore, lastId) => _buildList(
          context,
          transfers: transfers,
          hasMore: hasMore,
          l10n: l10n,
        ),
        error: (message) => _ErrorView(
          message: message,
          onRetry: () =>
              ref.read(transferHistoryProvider.notifier).loadFirstPage(),
        ),
      ),
    );
  }

  Widget _buildList(
    BuildContext context, {
    required List<Transfer> transfers,
    required bool hasMore,
    required AppLocalizations l10n,
  }) {
    final itemCount = transfers.length + (hasMore ? 1 : 0);

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        if (index == transfers.length) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Center(child: CircularProgressIndicator()),
          );
        }
        return _TransferTile(
          transfer: transfers[index],
          dateFormat: _dateFormat,
          sentTo: l10n.transfer_sent_to,
          receivedFrom: l10n.transfer_received_from,
        );
      },
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(message, textAlign: TextAlign.center),
          const SizedBox(height: 16),
          ElevatedButton(onPressed: onRetry, child: const Text('Reintentar')),
        ],
      ),
    );
  }
}

class _TransferTile extends StatelessWidget {
  final Transfer transfer;
  final DateFormat dateFormat;
  final String Function(String) sentTo;
  final String Function(String) receivedFrom;

  const _TransferTile({
    required this.transfer,
    required this.dateFormat,
    required this.sentTo,
    required this.receivedFrom,
  });

  @override
  Widget build(BuildContext context) {
    final isOutgoing = transfer.isOutgoing;
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: isOutgoing
              ? Theme.of(context).colorScheme.errorContainer
              : Theme.of(context).colorScheme.primaryContainer,
          child: Icon(
            isOutgoing ? Icons.arrow_upward : Icons.arrow_downward,
            color: isOutgoing
                ? Theme.of(context).colorScheme.onErrorContainer
                : Theme.of(context).colorScheme.onPrimaryContainer,
          ),
        ),
        title: Text(
          isOutgoing
              ? sentTo(transfer.toHolder)
              : receivedFrom(transfer.fromHolder),
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              '${transfer.fromAccountNumber} → ${transfer.toAccountNumber}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 2),
            Text(
              dateFormat.format(transfer.date),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        trailing: Text(
          '${isOutgoing ? '-' : '+'}${CurrencyFormat.formatGtq(transfer.amount)}',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: isOutgoing
                ? Theme.of(context).colorScheme.error
                : Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
    );
  }
}
