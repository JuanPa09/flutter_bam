import 'package:bam_wallet/features/loginV2/data/models/user_model.dart';

class User {
  final String accessToken;
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final String username;
  String get newId => 'new_$id';
  String get fullName => '$firstName $lastName';



  User({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    this.accessToken = '',
    this.username = '',
  });

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

}