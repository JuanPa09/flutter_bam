import 'package:bam_wallet/features/home/data/models/bank_account.dart';
import 'package:bam_wallet/features/home/data/models/transfer.dart';

interface class BankAccountDataSource {
  BankAccountDataSource();

  Future<List<BankAccount>> getAllAccounts() async {
    return [];
  }

  Future<List<Transfer>> getAllTransfers() async {
    return [];
  }
}
