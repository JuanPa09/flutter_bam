import 'package:freezed_annotation/freezed_annotation.dart';

part 'bank_account.freezed.dart';
part 'bank_account.g.dart';

@freezed
class BankAccount with _$BankAccount {
  const factory BankAccount({
    required String id,
    required String name,
    required String accountNumber,
    required String holderName,
    required double balance,
    required String currency,
    required String status,
  }) = _BankAccount;

  factory BankAccount.fromJson(Map<String, Object?> json) =>
      _$BankAccountFromJson(json);
}
