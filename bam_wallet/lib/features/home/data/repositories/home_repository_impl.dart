import 'package:bam_wallet/features/home/data/data_sources/bank_account_data_source.dart';
import 'package:bam_wallet/features/home/data/models/bank_account.dart';
import 'package:bam_wallet/features/home/data/models/transfer.dart';
import 'package:bam_wallet/features/home/domain/repositories/home_repository.dart';

class HomeRepositoryImpl implements HomeRepository {
  final BankAccountDataSource firebaseBankAccountDataSource;

  HomeRepositoryImpl({required this.firebaseBankAccountDataSource});

  @override
  Future<List<BankAccount>> getAccounts() async {
    final accounts = await firebaseBankAccountDataSource.getAllAccounts();
    return List<BankAccount>.from(accounts);
  }

  @override
  Future<List<Transfer>> getTransfers() async {
    final transfers = await firebaseBankAccountDataSource.getAllTransfers();
    return List<Transfer>.from(transfers);
  }

  @override
  Future<void> makeTransfer({
    required String fromAccountNumber,
    required String toAccountNumber,
    required double amount,
  }) async {
    // Implementation would go here for actual API calls
    // For now, just validate
    if (amount <= 0) {
      throw Exception('Amount must be greater than zero');
    }
  }
}
