import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bam_wallet/features/home/data/di/home_di.dart';
import 'package:bam_wallet/features/home/domain/use_cases/get_accounts_use_case.dart';
import 'package:bam_wallet/features/home/domain/use_cases/get_transfers_use_case.dart';
import 'package:bam_wallet/features/home/domain/use_cases/make_transfer_use_case.dart';
import 'package:bam_wallet/features/home/presentation/state/home_state.dart';

// Use Cases
final getAccountsUseCaseProvider = Provider((ref) {
  final repository = ref.watch(homeRepositoryProvider);
  return GetAccountsUseCase(repository: repository);
});

final getTransfersUseCaseProvider = Provider((ref) {
  final repository = ref.watch(homeRepositoryProvider);
  return GetTransfersUseCase(repository: repository);
});

final makeTransferUseCaseProvider = Provider((ref) {
  final repository = ref.watch(homeRepositoryProvider);
  return MakeTransferUseCase(repository: repository);
});

// Home State Notifier
class HomeNotifier extends StateNotifier<HomeState> {
  final GetAccountsUseCase _getAccountsUseCase;
  final GetTransfersUseCase _getTransfersUseCase;

  HomeNotifier({
    required GetAccountsUseCase getAccountsUseCase,
    required GetTransfersUseCase getTransfersUseCase,
  }) : _getAccountsUseCase = getAccountsUseCase,
       _getTransfersUseCase = getTransfersUseCase,
       super(const HomeState.initial()) {
    _loadHomeData();
  }

  Future<void> _loadHomeData() async {
    state = const HomeState.loading();
    try {
      final accounts = await _getAccountsUseCase();
      final transfers = await _getTransfersUseCase();
      state = HomeState.loaded(accounts: accounts, transfers: transfers);
    } catch (e, stackTrace) {
      print('Error loading home data: $e');
      print('Stack trace: $stackTrace');

      String errorMessage = 'Error desconocido';
      if (e is Exception) {
        errorMessage = e.toString().replaceAll('Exception: ', '');
      } else if (e != null) {
        errorMessage = e.toString();
      }

      state = HomeState.error(errorMessage);
    }
  }

  Future<void> refresh() async {
    await _loadHomeData();
  }
}

// Home State Provider
final homeStateProvider = StateNotifierProvider<HomeNotifier, HomeState>((ref) {
  final getAccountsUseCase = ref.watch(getAccountsUseCaseProvider);
  final getTransfersUseCase = ref.watch(getTransfersUseCaseProvider);

  return HomeNotifier(
    getAccountsUseCase: getAccountsUseCase,
    getTransfersUseCase: getTransfersUseCase,
  );
});

// Convenience providers
final homeAccountsProvider = Provider((ref) {
  final homeState = ref.watch(homeStateProvider);
  return homeState.whenOrNull(loaded: (accounts, _) => accounts) ?? [];
});

final homeTransfersProvider = Provider((ref) {
  final homeState = ref.watch(homeStateProvider);
  return homeState.whenOrNull(loaded: (_, transfers) => transfers) ?? [];
});
