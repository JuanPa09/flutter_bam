import 'package:bam_wallet/features/home/data/models/bank_account.dart';

abstract class BankAccountRepository {
  Future<List<BankAccount>> fetchBankAccounts();
}
