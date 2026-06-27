import 'package:bam_wallet/features/home/data/models/bank_account.dart';
import 'package:bam_wallet/features/home/data/models/transfer.dart';

abstract class HomeDataSource {
  Future<List<BankAccount>> getAccounts();
  Future<List<Transfer>> getTransfers();
}
