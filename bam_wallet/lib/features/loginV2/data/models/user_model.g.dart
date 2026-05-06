// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserModelImpl _$$UserModelImplFromJson(Map<String, dynamic> json) =>
    _$UserModelImpl(
      id: _stringFromDynamic(json['id']),
      username: json['username'] as String,
      email: json['email'] as String,
      firstName: _stringFromDynamic(json['firstName']),
      lastName: _stringFromDynamic(json['lastName']),
      gender: _stringFromDynamic(json['gender']),
      image: _stringFromDynamic(json['image']),
      accessToken: json['accessToken'] as String,
    );

Map<String, dynamic> _$$UserModelImplToJson(_$UserModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'email': instance.email,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'gender': instance.gender,
      'image': instance.image,
      'accessToken': instance.accessToken,
    };
