import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:bam_wallet/features/home/domain/entities/bank_account_entity.dart';
import 'package:bam_wallet/features/home/domain/entities/transfer_entity.dart';

part 'home_state.freezed.dart';

@freezed
sealed class HomeState with _$HomeState {
  const factory HomeState.initial() = _Initial;
  const factory HomeState.loading() = _Loading;
  const factory HomeState.loaded({
    required List<BankAccount> accounts,
    required List<Transfer> transfers,
  }) = _Loaded;
  const factory HomeState.error(String message) = _Error;
}
