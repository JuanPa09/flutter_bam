import 'package:bam_wallet/features/home/data/data_sources/home_data_source.dart';
import 'package:bam_wallet/features/home/data/models/bank_account.dart';
import 'package:bam_wallet/features/home/data/models/transfer.dart';
import 'package:bam_wallet/features/home/domain/repositories/home_repository.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeDataSource dataSource;

  HomeRepositoryImpl({required this.dataSource});

  @override
  Future<List<BankAccount>> getAccounts() {
    return dataSource.getAccounts();
  }

  @override
  Future<List<Transfer>> getTransfers() {
    return dataSource.getTransfers();
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
