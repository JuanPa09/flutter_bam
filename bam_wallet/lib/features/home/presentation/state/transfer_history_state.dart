import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:bam_wallet/features/home/domain/entities/transfer_entity.dart';

part 'transfer_history_state.freezed.dart';

@freezed
sealed class TransferHistoryState with _$TransferHistoryState {
  const factory TransferHistoryState.initial() = _Initial;
  const factory TransferHistoryState.loading() = _Loading;
  const factory TransferHistoryState.loaded({
    required List<Transfer> transfers,
    required bool hasMore,
    @Default(false) bool isLoadingMore,
    String? lastId,
  }) = _Loaded;
  const factory TransferHistoryState.error(String message) = _Error;
}
