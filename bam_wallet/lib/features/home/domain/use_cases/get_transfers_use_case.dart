import 'package:bam_wallet/features/home/domain/models/transfer.dart';
import 'package:bam_wallet/features/home/domain/repositories/home_repository.dart';

class GetTransfersUseCase {
  final HomeRepository repository;

  GetTransfersUseCase({required this.repository});

  Future<List<Transfer>> call() async {
    return repository.getTransfers();
  }
}
