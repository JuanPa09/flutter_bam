import 'package:bam_wallet/features/home/domain/models/bank_account.dart';
import 'package:bam_wallet/features/home/domain/models/transfer.dart';

abstract class HomeRepository {
  Future<List<BankAccount>> getAccounts();
  Future<List<Transfer>> getTransfers();
  Future<void> makeTransfer({
    required String fromAccountNumber,
    required String toAccountNumber,
    required double amount,
  });
}
