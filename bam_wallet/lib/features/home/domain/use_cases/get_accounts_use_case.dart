import 'package:bam_wallet/features/home/domain/models/bank_account.dart';
import 'package:bam_wallet/features/home/domain/repositories/home_repository.dart';

class GetAccountsUseCase {
  final HomeRepository repository;

  GetAccountsUseCase({required this.repository});

  Future<List<BankAccount>> call() async {
    return repository.getAccounts();
  }
}
