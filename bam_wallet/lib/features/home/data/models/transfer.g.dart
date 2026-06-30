// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transfer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TransferImpl _$$TransferImplFromJson(Map<String, dynamic> json) =>
    _$TransferImpl(
      id: json['id'] as String,
      fromAccountNumber: json['fromAccountNumber'] as String,
      toAccountNumber: json['toAccountNumber'] as String,
      fromHolder: json['fromHolder'] as String,
      toHolder: json['toHolder'] as String,
      amount: (json['amount'] as num).toDouble(),
      currency: json['currency'] as String,
      date: DateTime.parse(json['date'] as String),
      isOutgoing: json['isOutgoing'] as bool,
    );

Map<String, dynamic> _$$TransferImplToJson(_$TransferImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'fromAccountNumber': instance.fromAccountNumber,
      'toAccountNumber': instance.toAccountNumber,
      'fromHolder': instance.fromHolder,
      'toHolder': instance.toHolder,
      'amount': instance.amount,
      'currency': instance.currency,
      'date': instance.date.toIso8601String(),
      'isOutgoing': instance.isOutgoing,
    };
