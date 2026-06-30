// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bank_account_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BankAccountModelImpl _$$BankAccountModelImplFromJson(
  Map<String, dynamic> json,
) => _$BankAccountModelImpl(
  id: json['id'] as String,
  name: json['name'] as String,
  accountNumber: json['accountNumber'] as String,
  holderName: json['holderName'] as String,
  balance: (json['balance'] as num).toDouble(),
  currency: json['currency'] as String,
  status: json['status'] as String,
);

Map<String, dynamic> _$$BankAccountModelImplToJson(
  _$BankAccountModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'accountNumber': instance.accountNumber,
  'holderName': instance.holderName,
  'balance': instance.balance,
  'currency': instance.currency,
  'status': instance.status,
};
