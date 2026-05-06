class UserPasswordModel {

  final String username;
  final String password;

  UserPasswordModel({
    required this.username,
    required this.password,
  });

  factory UserPasswordModel.fromEntity(Map<String, dynamic> json) {
    return UserPasswordModel(
      username: json['username'],
      password: json['password'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'password': password,
    };
  }
  



}