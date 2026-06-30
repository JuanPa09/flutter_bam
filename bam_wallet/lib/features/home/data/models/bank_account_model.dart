import 'package:freezed_annotation/freezed_annotation.dart';

part 'bank_account_model.freezed.dart';
part 'bank_account_model.g.dart';

@freezed
class BankAccountModel with _$BankAccountModel {
  const factory BankAccountModel({
    required String id,
    required String name,
    required String accountNumber,
    required String holderName,
    required double balance,
    required String currency,
    required String status,
  }) = _BankAccountModel;

  factory BankAccountModel.fromJson(Map<String, Object?> json) =>
      _$BankAccountModelFromJson(json);
}
