import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_state.freezed.dart';

@freezed
sealed class LoginState with _$LoginState {
  const factory LoginState.initial() = _Initial;
  const factory LoginState.loading() = _Loading;
  const factory LoginState.checkingCache() = _CheckingCache;
  const factory LoginState.success(String username) = _Success;
  const factory LoginState.error(String errorMessage) = _Error;
}
