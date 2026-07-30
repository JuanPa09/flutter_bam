import 'package:bam_wallet/features/home/data/data_sources/bank_account_data_source.dart';
import 'package:bam_wallet/features/home/data/models/bank_account_model.dart';
import 'package:bam_wallet/features/home/data/models/transfer_model.dart';
import 'package:bam_wallet/features/home/domain/entities/bank_account_entity.dart';
import 'package:bam_wallet/features/home/domain/entities/transfer_entity.dart';
import 'package:bam_wallet/features/home/domain/entities/transfer_page_entity.dart';
import 'package:bam_wallet/features/home/domain/repositories/home_repository.dart';

class HomeRepositoryImpl implements HomeRepository {
  final BankAccountDataSource firebaseBankAccountDataSource;

  HomeRepositoryImpl({required this.firebaseBankAccountDataSource});

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
  }) async {
    if (amount <= 0) {
      throw Exception('Amount must be greater than zero');
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
