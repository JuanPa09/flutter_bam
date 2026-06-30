import 'package:bam_wallet/features/home/data/models/bank_account.dart';
import 'package:bam_wallet/features/home/data/data_sources/firebase_bank_account_data_source.dart';
import 'package:bam_wallet/features/home/domain/repositories/bank_account_repository.dart';

class BankAccountRepositoryImpl extends BankAccountRepository {
  final FirebaseBankAccountDataSource firebaseBankAccountDataSource =
      FirebaseBankAccountDataSource();

  @override
  Future<List<BankAccount>> fetchBankAccounts() async {
    final accounts = await firebaseBankAccountDataSource.getAllAccounts();
    print('fetchBankAccounts retrieved ${accounts.length} accounts');
    return List<BankAccount>.from(accounts);
  }
}
