import 'package:bam_wallet/features/home/domain/models/bank_account.dart';
import 'package:bam_wallet/features/home/domain/models/transfer.dart';

abstract class HomeDataSource {
  Future<List<BankAccount>> getAccounts();
  Future<List<Transfer>> getTransfers();
}
