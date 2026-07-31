import 'package:bam_wallet/core/notifications/domain/repositories/notification_repository.dart';
import 'package:bam_wallet/features/home/data/data_sources/bank_account_data_source.dart';
import 'package:bam_wallet/features/home/data/models/bank_account_model.dart';
import 'package:bam_wallet/features/home/data/models/transfer_model.dart';
import 'package:bam_wallet/features/home/domain/entities/bank_account_entity.dart';
import 'package:bam_wallet/features/home/domain/entities/transfer_entity.dart';
import 'package:bam_wallet/features/home/domain/entities/transfer_page_entity.dart';
import 'package:bam_wallet/features/home/domain/repositories/home_repository.dart';

class HomeRepositoryImpl implements HomeRepository {
  final BankAccountDataSource firebaseBankAccountDataSource;
  final NotificationRepository notificationRepository;

  HomeRepositoryImpl({
    required this.firebaseBankAccountDataSource,
    required this.notificationRepository,
  });

  @override
  Future<List<BankAccount>> getAccounts() async {
    final models = await firebaseBankAccountDataSource.getAllAccounts();
    return models.map(_toAccountEntity).toList();
  }

  @override
  Future<List<Transfer>> getTransfers() async {
    final models = await firebaseBankAccountDataSource.getAllTransfers();
    return models.map(_toTransferEntity).toList();
  }

  @override
  Future<TransferPage> getTransfersPage({
    String? afterId,
    int limit = 10,
  }) async {
    final result = await firebaseBankAccountDataSource.getTransfersPage(
      afterDocumentId: afterId,
      limit: limit,
    );
    return TransferPage(
      items: result.items.map(_toTransferEntity).toList(),
      hasMore: result.hasMore,
      lastId: result.lastId,
    );
  }

  @override
  Future<void> makeTransfer({
    required String fromAccountNumber,
    required String toAccountNumber,
    required double amount,
    required String userId,
  }) async {
    if (amount <= 0) {
      throw Exception('Amount must be greater than zero');
    }

    try {
      // Obtener cuentas de origen
      final allAccounts = await firebaseBankAccountDataSource.getAllAccounts();

      final fromAccount = allAccounts.firstWhere(
        (account) => account.accountNumber == fromAccountNumber,
        orElse: () => throw Exception('Source account not found'),
      );

      // Validar saldo
      if (fromAccount.balance < amount) {
        throw Exception('Insufficient balance');
      }

      // Crear modelo de transferencia (sin validar cuenta destino)
      final transfer = TransferModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        fromAccountNumber: fromAccountNumber,
        toAccountNumber: toAccountNumber,
        fromHolder: fromAccount.holderName,
        toHolder:
            toAccountNumber, // Usar el número de cuenta como nombre del titular
        amount: amount,
        currency: fromAccount.currency,
        date: DateTime.now(),
        isOutgoing: true,
      );

      // Guardar la transferencia
      await firebaseBankAccountDataSource.saveTransfer(transfer);

      // Actualizar el balance de la cuenta origen
      final newBalance = fromAccount.balance - amount;
      await firebaseBankAccountDataSource.updateAccountBalance(
        accountNumber: fromAccountNumber,
        newBalance: newBalance,
      );

      // Enviar notificación push
      print('[TRANSFER] About to send notification for user: $userId');
      await notificationRepository.sendNotification(
        userId: userId,
        title: 'Transferencia Realizada',
        body:
            'Se transfirieron $amount ${transfer.currency} a $toAccountNumber',
        data: {
          'type': 'transfer',
          'transferId': transfer.id,
          'amount': amount.toString(),
          'toAccount': toAccountNumber,
        },
      );
      print('[TRANSFER] ✅ Transfer completed with notification');
    } catch (e) {
      print('[TRANSFER] ❌ Error during transfer: $e');
      throw Exception('Error making transfer: $e');
    }
  }

  BankAccount _toAccountEntity(BankAccountModel model) => BankAccount(
    id: model.id,
    name: model.name,
    accountNumber: model.accountNumber,
    holderName: model.holderName,
    balance: model.balance,
    currency: model.currency,
    status: model.status,
  );

  Transfer _toTransferEntity(TransferModel model) => Transfer(
    id: model.id,
    fromAccountNumber: model.fromAccountNumber,
    toAccountNumber: model.toAccountNumber,
    fromHolder: model.fromHolder,
    toHolder: model.toHolder,
    amount: model.amount,
    currency: model.currency,
    date: model.date,
    isOutgoing: model.isOutgoing,
  );
}
