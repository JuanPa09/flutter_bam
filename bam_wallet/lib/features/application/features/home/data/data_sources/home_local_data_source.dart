import 'package:bam_wallet/features/application/features/home/data/data_sources/home_data_source.dart';
import 'package:bam_wallet/features/application/features/home/data/mock/home_mock_data.dart';
import 'package:bam_wallet/features/application/features/home/domain/models/bank_account.dart';
import 'package:bam_wallet/features/application/features/home/domain/models/transfer.dart';

class HomeLocalDataSource implements HomeDataSource {
  @override
  Future<List<BankAccount>> getAccounts() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    return HomeMockData.accounts;
  }

  @override
  Future<List<Transfer>> getTransfers() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    return HomeMockData.transfers;
  }
}
