import 'package:bam_wallet/features/home/domain/entities/bank_account_entity.dart';
import 'package:bam_wallet/features/home/domain/entities/transfer_entity.dart';
import 'package:bam_wallet/features/home/domain/entities/transfer_page_entity.dart';

abstract class HomeRepository {
  Future<List<BankAccount>> getAccounts();
  Future<List<Transfer>> getTransfers();
  Future<TransferPage> getTransfersPage({String? afterId, int limit = 10});
  Future<void> makeTransfer({
    required String fromAccountNumber,
    required String toAccountNumber,
    required double amount,
    required String userId,
  });
}
