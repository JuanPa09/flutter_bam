import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_password_model.freezed.dart';

@freezed
class UserPasswordModel with _$UserPasswordModel {
  const factory UserPasswordModel({
    required String username,
    required String password,
  }) = _UserPasswordModel;

  const UserPasswordModel._();

  Map<String, dynamic> toJson() => {
    'username': username,
    'password': password,
  };
}
