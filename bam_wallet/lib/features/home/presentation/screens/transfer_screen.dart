import 'package:bam_wallet/core/utils/currency_format.dart';
import 'package:bam_wallet/features/home/domain/entities/bank_account_entity.dart';
import 'package:bam_wallet/features/home/presentation/providers/home_providers.dart';
import 'package:bam_wallet/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class TransferScreen extends ConsumerStatefulWidget {
  const TransferScreen({super.key});

  @override
  ConsumerState<TransferScreen> createState() => _TransferScreenState();
}

class _TransferScreenState extends ConsumerState<TransferScreen> {
  BankAccount? _selectedAccount;
  final TextEditingController _destinationController = TextEditingController();
  String _amountStr = '';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final accounts = ref.read(homeAccountsProvider);
    if (accounts.isNotEmpty) _selectedAccount = accounts.first;
  }

  @override
  void dispose() {
    _destinationController.dispose();
    super.dispose();
  }

  void _onKeyPressed(String key) {
    setState(() {
      if (key == 'borrar') {
        if (_amountStr.isNotEmpty) {
          _amountStr = _amountStr.substring(0, _amountStr.length - 1);
        }
        return;
      }
      if (key == '.') {
        if (_amountStr.contains('.')) {
          return;
        }
        if (_amountStr.isEmpty) {
          _amountStr = '0.';
        } else {
          _amountStr += '.';
        }
        return;
      }
      if (_amountStr == '0' && key != '.') {
        _amountStr = key;
      } else {
        _amountStr += key;
      }
    });
  }

  Future<void> _handleTransfer() async {
    final destination = _destinationController.text.trim();
    final amount = double.tryParse(_amountStr);
    if (_selectedAccount == null ||
        destination.isEmpty ||
        amount == null ||
        amount <= 0) {
      return;
    }

    setState(() => _isLoading = true);
    try {
      await ref
          .read(makeTransferUseCaseProvider)
          .call(
            fromAccountNumber: _selectedAccount!.accountNumber,
            toAccountNumber: destination,
            amount: amount,
          );
      if (mounted) {
        ref.read(homeStateProvider.notifier).refresh();
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final accounts = ref.watch(homeAccountsProvider);

    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.transfer_title),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DropdownButtonFormField<BankAccount>(
              initialValue: _selectedAccount,
              decoration: InputDecoration(
                labelText: l10n.transfer_source_account,
                border: const OutlineInputBorder(),
              ),
              items: accounts
                  .map(
                    (a) => DropdownMenuItem(
                      value: a,
                      child: Text('${a.accountNumber} - ${a.holderName}'),
                    ),
                  )
                  .toList(),
              onChanged: (v) => setState(() => _selectedAccount = v),
            ),
            const SizedBox(height: 16),
            TextField(
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              controller: _destinationController,
              decoration: InputDecoration(
                labelText: l10n.transfer_destination_account,
                border: const OutlineInputBorder(),
                hintText: l10n.transfer_destination_hint,
              ),
              keyboardType: TextInputType.number,
              onTapOutside: (event) => FocusScope.of(context).unfocus(),
            ),
            const SizedBox(height: 24),
            Text(
              l10n.transfer_amount,
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                CurrencyFormat.formatGtqFromString(
                  _amountStr.isEmpty ? '0' : _amountStr,
                ),
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 24),
            _NumericKeypad(onKeyPressed: _onKeyPressed),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _isLoading ? null : _handleTransfer,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(l10n.transfer_do_transfer),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NumericKeypad extends StatelessWidget {
  final void Function(String) onKeyPressed;

  const _NumericKeypad({required this.onKeyPressed});

  static const List<String> _row1 = ['1', '2', '3'];
  static const List<String> _row2 = ['4', '5', '6'];
  static const List<String> _row3 = ['7', '8', '9'];
  static const List<String> _row4 = ['.', '0', 'borrar'];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildRow(context, _row1),
        const SizedBox(height: 8),
        _buildRow(context, _row2),
        const SizedBox(height: 8),
        _buildRow(context, _row3),
        const SizedBox(height: 8),
        _buildRow(context, _row4),
      ],
    );
  }

  Widget _buildRow(BuildContext context, List<String> keys) {
    return Row(
      children: keys.map((key) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: key == 'borrar'
                ? IconButton(
                    onPressed: () => onKeyPressed('borrar'),
                    icon: const Icon(Icons.backspace_outlined),
                    style: IconButton.styleFrom(
                      backgroundColor: Theme.of(
                        context,
                      ).colorScheme.surfaceContainerHighest,
                    ),
                  )
                : ElevatedButton(
                    onPressed: () => onKeyPressed(key),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text(key, style: const TextStyle(fontSize: 20)),
                  ),
          ),
        );
      }).toList(),
    );
  }
}
