import 'package:bam_wallet/features/home/domain/entities/bank_account_entity.dart';
import 'package:bam_wallet/features/home/domain/entities/transfer_entity.dart';

abstract class HomeRepository {
  Future<List<BankAccount>> getAccounts();
  Future<List<Transfer>> getTransfers();
  Future<void> makeTransfer({
    required String fromAccountNumber,
    required String toAccountNumber,
    required double amount,
  });
}
