import 'package:bam_wallet/features/home/domain/entities/transfer_entity.dart';

class TransferPage {
  final List<Transfer> items;
  final bool hasMore;
  final String? lastId;

  const TransferPage({
    required this.items,
    required this.hasMore,
    this.lastId,
  });
}
