import 'package:bam_wallet/features/application/features/home/domain/repositories/home_repository.dart';

class MakeTransferUseCase {
  final HomeRepository repository;

  MakeTransferUseCase({required this.repository});

  Future<void> call({
    required String fromAccountNumber,
    required String toAccountNumber,
    required double amount,
  }) async {
    return repository.makeTransfer(
      fromAccountNumber: fromAccountNumber,
      toAccountNumber: toAccountNumber,
      amount: amount,
    );
  }
}
