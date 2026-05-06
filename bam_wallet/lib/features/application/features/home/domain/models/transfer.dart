import 'package:freezed_annotation/freezed_annotation.dart';

part 'transfer.freezed.dart';

@freezed
class Transfer with _$Transfer {
  const factory Transfer({
    required String id,
    required String fromAccountNumber,
    required String toAccountNumber,
    required String fromHolder,
    required String toHolder,
    required double amount,
    required String currency,
    required DateTime date,
    required bool isOutgoing,
  }) = _Transfer;
}
