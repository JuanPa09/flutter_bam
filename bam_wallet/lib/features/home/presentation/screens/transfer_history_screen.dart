import 'package:bam_wallet/core/utils/currency_format.dart';
import 'package:bam_wallet/features/home/data/models/transfer.dart';
import 'package:bam_wallet/features/home/presentation/providers/home_providers.dart';
import 'package:bam_wallet/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class TransferHistoryScreen extends ConsumerWidget {
  const TransferHistoryScreen({super.key});

  static final _dateFormat = DateFormat('d/MM/yyyy HH:mm');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transfers = ref.watch(homeTransfersProvider);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.transfer_history_title),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: transfers.length,
        itemBuilder: (context, index) {
          final t = transfers[index];
          return _TransferTile(
            transfer: t,
            dateFormat: _dateFormat,
            sentTo: l10n.transfer_sent_to,
            receivedFrom: l10n.transfer_received_from,
          );
        },
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
