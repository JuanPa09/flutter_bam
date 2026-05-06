import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bam_wallet/features/application/features/home/data/data_sources/home_local_data_source.dart';
import 'package:bam_wallet/features/application/features/home/data/repositories/home_repository_impl.dart';
import 'package:bam_wallet/features/application/features/home/domain/use_cases/get_accounts_use_case.dart';
import 'package:bam_wallet/features/application/features/home/domain/use_cases/get_transfers_use_case.dart';
import 'package:bam_wallet/features/application/features/home/domain/use_cases/make_transfer_use_case.dart';
import 'package:bam_wallet/features/application/features/home/presentation/state/home_state.dart';

// Data Sources
final homeDataSourceProvider = Provider<HomeLocalDataSource>((ref) {
  return HomeLocalDataSource();
});

// Repository
final homeRepositoryProvider = Provider((ref) {
  final dataSource = ref.watch(homeDataSourceProvider);
  return HomeRepositoryImpl(dataSource: dataSource);
});

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
    } catch (e) {
      state = HomeState.error(e.toString());
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
