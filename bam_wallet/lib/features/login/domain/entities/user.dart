import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:bam_wallet/features/login/data/models/user_model.dart';

part 'user.freezed.dart';

@freezed
class User with _$User {
  const factory User({
    required String id,
    required String email,
    required String firstName,
    required String lastName,
    @Default('') String accessToken,
    @Default('') String username,
  }) = _User;

  const User._();

  factory User.fromModel(UserModel userModel) {
    return User(
      id: userModel.id,
      email: userModel.email,
      firstName: userModel.firstName,
      lastName: userModel.lastName,
      accessToken: userModel.accessToken,
      username: userModel.username,
    );
  }

  String get newId => 'new_$id';
  String get fullName => '$firstName $lastName';
}
