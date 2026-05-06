import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    @JsonKey(fromJson: _stringFromDynamic) required String id,
    required String username,
    required String email,
    @JsonKey(fromJson: _stringFromDynamic) required String firstName,
    @JsonKey(fromJson: _stringFromDynamic) required String lastName,
    @JsonKey(fromJson: _stringFromDynamic) required String gender,
    @JsonKey(fromJson: _stringFromDynamic) required String image,
    required String accessToken,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}

// Converter function to handle both String and int values
String _stringFromDynamic(dynamic value) {
  if (value is String) return value;
  if (value is int) return value.toString();
  if (value == null) return '';
  return value.toString();
}
