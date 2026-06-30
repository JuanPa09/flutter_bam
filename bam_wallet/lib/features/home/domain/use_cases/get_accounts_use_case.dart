import 'package:bam_wallet/features/home/domain/entities/bank_account_entity.dart';
import 'package:bam_wallet/features/home/domain/repositories/home_repository.dart';

class GetAccountsUseCase {
  final HomeRepository repository;

  GetAccountsUseCase({required this.repository});

  Future<List<BankAccount>> call() async {
    return repository.getAccounts();
  }
}
