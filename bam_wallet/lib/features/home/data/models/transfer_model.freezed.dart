// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transfer_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

TransferModel _$TransferModelFromJson(Map<String, dynamic> json) {
  return _TransferModel.fromJson(json);
}

/// @nodoc
mixin _$TransferModel {
  String get id => throw _privateConstructorUsedError;
  String get fromAccountNumber => throw _privateConstructorUsedError;
  String get toAccountNumber => throw _privateConstructorUsedError;
  String get fromHolder => throw _privateConstructorUsedError;
  String get toHolder => throw _privateConstructorUsedError;
  double get amount => throw _privateConstructorUsedError;
  String get currency => throw _privateConstructorUsedError;
  DateTime get date => throw _privateConstructorUsedError;
  bool get isOutgoing => throw _privateConstructorUsedError;

  /// Serializes this TransferModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TransferModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TransferModelCopyWith<TransferModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TransferModelCopyWith<$Res> {
  factory $TransferModelCopyWith(
    TransferModel value,
    $Res Function(TransferModel) then,
  ) = _$TransferModelCopyWithImpl<$Res, TransferModel>;
  @useResult
  $Res call({
    String id,
    String fromAccountNumber,
    String toAccountNumber,
    String fromHolder,
    String toHolder,
    double amount,
    String currency,
    DateTime date,
    bool isOutgoing,
  });
}

/// @nodoc
class _$TransferModelCopyWithImpl<$Res, $Val extends TransferModel>
    implements $TransferModelCopyWith<$Res> {
  _$TransferModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TransferModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? fromAccountNumber = null,
    Object? toAccountNumber = null,
    Object? fromHolder = null,
    Object? toHolder = null,
    Object? amount = null,
    Object? currency = null,
    Object? date = null,
    Object? isOutgoing = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            fromAccountNumber: null == fromAccountNumber
                ? _value.fromAccountNumber
                : fromAccountNumber // ignore: cast_nullable_to_non_nullable
                      as String,
            toAccountNumber: null == toAccountNumber
                ? _value.toAccountNumber
                : toAccountNumber // ignore: cast_nullable_to_non_nullable
                      as String,
            fromHolder: null == fromHolder
                ? _value.fromHolder
                : fromHolder // ignore: cast_nullable_to_non_nullable
                      as String,
            toHolder: null == toHolder
                ? _value.toHolder
                : toHolder // ignore: cast_nullable_to_non_nullable
                      as String,
            amount: null == amount
                ? _value.amount
                : amount // ignore: cast_nullable_to_non_nullable
                      as double,
            currency: null == currency
                ? _value.currency
                : currency // ignore: cast_nullable_to_non_nullable
                      as String,
            date: null == date
                ? _value.date
                : date // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            isOutgoing: null == isOutgoing
                ? _value.isOutgoing
                : isOutgoing // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TransferModelImplCopyWith<$Res>
    implements $TransferModelCopyWith<$Res> {
  factory _$$TransferModelImplCopyWith(
    _$TransferModelImpl value,
    $Res Function(_$TransferModelImpl) then,
  ) = __$$TransferModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String fromAccountNumber,
    String toAccountNumber,
    String fromHolder,
    String toHolder,
    double amount,
    String currency,
    DateTime date,
    bool isOutgoing,
  });
}

/// @nodoc
class __$$TransferModelImplCopyWithImpl<$Res>
    extends _$TransferModelCopyWithImpl<$Res, _$TransferModelImpl>
    implements _$$TransferModelImplCopyWith<$Res> {
  __$$TransferModelImplCopyWithImpl(
    _$TransferModelImpl _value,
    $Res Function(_$TransferModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TransferModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? fromAccountNumber = null,
    Object? toAccountNumber = null,
    Object? fromHolder = null,
    Object? toHolder = null,
    Object? amount = null,
    Object? currency = null,
    Object? date = null,
    Object? isOutgoing = null,
  }) {
    return _then(
      _$TransferModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        fromAccountNumber: null == fromAccountNumber
            ? _value.fromAccountNumber
            : fromAccountNumber // ignore: cast_nullable_to_non_nullable
                  as String,
        toAccountNumber: null == toAccountNumber
            ? _value.toAccountNumber
            : toAccountNumber // ignore: cast_nullable_to_non_nullable
                  as String,
        fromHolder: null == fromHolder
            ? _value.fromHolder
            : fromHolder // ignore: cast_nullable_to_non_nullable
                  as String,
        toHolder: null == toHolder
            ? _value.toHolder
            : toHolder // ignore: cast_nullable_to_non_nullable
                  as String,
        amount: null == amount
            ? _value.amount
            : amount // ignore: cast_nullable_to_non_nullable
                  as double,
        currency: null == currency
            ? _value.currency
            : currency // ignore: cast_nullable_to_non_nullable
                  as String,
        date: null == date
            ? _value.date
            : date // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        isOutgoing: null == isOutgoing
            ? _value.isOutgoing
            : isOutgoing // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TransferModelImpl implements _TransferModel {
  const _$TransferModelImpl({
    required this.id,
    required this.fromAccountNumber,
    required this.toAccountNumber,
    required this.fromHolder,
    required this.toHolder,
    required this.amount,
    required this.currency,
    required this.date,
    required this.isOutgoing,
  });

  factory _$TransferModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$TransferModelImplFromJson(json);

  @override
  final String id;
  @override
  final String fromAccountNumber;
  @override
  final String toAccountNumber;
  @override
  final String fromHolder;
  @override
  final String toHolder;
  @override
  final double amount;
  @override
  final String currency;
  @override
  final DateTime date;
  @override
  final bool isOutgoing;

  @override
  String toString() {
    return 'TransferModel(id: $id, fromAccountNumber: $fromAccountNumber, toAccountNumber: $toAccountNumber, fromHolder: $fromHolder, toHolder: $toHolder, amount: $amount, currency: $currency, date: $date, isOutgoing: $isOutgoing)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TransferModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.fromAccountNumber, fromAccountNumber) ||
                other.fromAccountNumber == fromAccountNumber) &&
            (identical(other.toAccountNumber, toAccountNumber) ||
                other.toAccountNumber == toAccountNumber) &&
            (identical(other.fromHolder, fromHolder) ||
                other.fromHolder == fromHolder) &&
            (identical(other.toHolder, toHolder) ||
                other.toHolder == toHolder) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.isOutgoing, isOutgoing) ||
                other.isOutgoing == isOutgoing));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    fromAccountNumber,
    toAccountNumber,
    fromHolder,
    toHolder,
    amount,
    currency,
    date,
    isOutgoing,
  );

  /// Create a copy of TransferModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TransferModelImplCopyWith<_$TransferModelImpl> get copyWith =>
      __$$TransferModelImplCopyWithImpl<_$TransferModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TransferModelImplToJson(this);
  }
}

abstract class _TransferModel implements TransferModel {
  const factory _TransferModel({
    required final String id,
    required final String fromAccountNumber,
    required final String toAccountNumber,
    required final String fromHolder,
    required final String toHolder,
    required final double amount,
    required final String currency,
    required final DateTime date,
    required final bool isOutgoing,
  }) = _$TransferModelImpl;

  factory _TransferModel.fromJson(Map<String, dynamic> json) =
      _$TransferModelImpl.fromJson;

  @override
  String get id;
  @override
  String get fromAccountNumber;
  @override
  String get toAccountNumber;
  @override
  String get fromHolder;
  @override
  String get toHolder;
  @override
  double get amount;
  @override
  String get currency;
  @override
  DateTime get date;
  @override
  bool get isOutgoing;

  /// Create a copy of TransferModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TransferModelImplCopyWith<_$TransferModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
