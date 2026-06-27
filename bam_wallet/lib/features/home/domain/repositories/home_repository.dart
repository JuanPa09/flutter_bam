import 'package:bam_wallet/features/home/data/models/bank_account.dart';
import 'package:bam_wallet/features/home/data/models/transfer.dart';

abstract class HomeRepository {
  Future<List<BankAccount>> getAccounts();
  Future<List<Transfer>> getTransfers();
  Future<void> makeTransfer({
    required String fromAccountNumber,
    required String toAccountNumber,
    required double amount,
  });
}
