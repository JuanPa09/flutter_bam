import 'package:bam_wallet/features/home/domain/entities/transfer_page_entity.dart';
import 'package:bam_wallet/features/home/domain/repositories/home_repository.dart';

class GetTransfersPageUseCase {
  final HomeRepository repository;

  GetTransfersPageUseCase({required this.repository});

  Future<TransferPage> call({String? afterId, int limit = 10}) {
    return repository.getTransfersPage(afterId: afterId, limit: limit);
  }
}
