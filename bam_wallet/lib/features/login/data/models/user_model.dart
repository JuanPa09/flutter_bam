import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';

@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    required String id,
    required String username,
    required String email,
    required String firstName,
    required String lastName,
    required String gender,
    required String image,
    required String accessToken,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: _stringFromDynamic(json['id']),
      username: json['username'] as String? ?? '',
      email: json['email'] as String? ?? '',
      firstName: _stringFromDynamic(json['firstName']),
      lastName: _stringFromDynamic(json['lastName']),
      gender: _stringFromDynamic(json['gender']),
      image: _stringFromDynamic(json['image']),
      accessToken: json['accessToken'] as String? ?? '',
    );
  }
}

// Converter function to handle both String and int values
String _stringFromDynamic(dynamic value) {
  if (value is String) return value;
  if (value is int) return value.toString();
  if (value == null) return '';
  return value.toString();
}
