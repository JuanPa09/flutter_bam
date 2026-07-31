import 'package:bam_wallet/features/home/data/di/home_di.dart';
import 'package:bam_wallet/features/home/domain/use_cases/get_transfers_page_use_case.dart';
import 'package:bam_wallet/features/home/presentation/state/transfer_history_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getTransfersPageUseCaseProvider = Provider((ref) {
  return GetTransfersPageUseCase(repository: ref.watch(homeRepositoryProvider));
});

class TransferHistoryNotifier extends StateNotifier<TransferHistoryState> {
  final GetTransfersPageUseCase _useCase;
  static const int _pageSize = 10;

  TransferHistoryNotifier(this._useCase)
    : super(const TransferHistoryState.initial()) {
    loadFirstPage();
  }

  Future<void> loadFirstPage() async {
    state = const TransferHistoryState.loading();
    try {
      final page = await _useCase(limit: _pageSize);
      state = TransferHistoryState.loaded(
        transfers: page.items,
        hasMore: page.hasMore,
        lastId: page.lastId,
      );
    } catch (e) {
      state = TransferHistoryState.error(
        e.toString().replaceAll('Exception: ', ''),
      );
    }
  }

  Future<void> loadMore() async {
    final loaded = state.whenOrNull(
      loaded: (transfers, hasMore, isLoadingMore, lastId) => (
        transfers: transfers,
        hasMore: hasMore,
        isLoadingMore: isLoadingMore,
        lastId: lastId,
      ),
    );

    if (loaded == null || !loaded.hasMore || loaded.isLoadingMore) return;

    state = TransferHistoryState.loaded(
      transfers: loaded.transfers,
      hasMore: loaded.hasMore,
      isLoadingMore: true,
      lastId: loaded.lastId,
    );

    try {
      final page = await _useCase(afterId: loaded.lastId, limit: _pageSize);
      state = TransferHistoryState.loaded(
        transfers: [...loaded.transfers, ...page.items],
        hasMore: page.hasMore,
        isLoadingMore: false,
        lastId: page.lastId,
      );
    } catch (_) {
      state = TransferHistoryState.loaded(
        transfers: loaded.transfers,
        hasMore: loaded.hasMore,
        isLoadingMore: false,
        lastId: loaded.lastId,
      );
    }
  }
}

final transferHistoryProvider =
    StateNotifierProvider.autoDispose<
      TransferHistoryNotifier,
      TransferHistoryState
    >((ref) {
      return TransferHistoryNotifier(
        ref.watch(getTransfersPageUseCaseProvider),
      );
    });
