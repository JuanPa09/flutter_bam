import 'package:freezed_annotation/freezed_annotation.dart';

part 'transfer_model.freezed.dart';
part 'transfer_model.g.dart';

@freezed
class TransferModel with _$TransferModel {
  const factory TransferModel({
    required String id,
    required String fromAccountNumber,
    required String toAccountNumber,
    required String fromHolder,
    required String toHolder,
    required double amount,
    required String currency,
    required DateTime date,
    required bool isOutgoing,
  }) = _TransferModel;

  factory TransferModel.fromJson(Map<String, dynamic> json) =>
      _$TransferModelFromJson(json);
}
