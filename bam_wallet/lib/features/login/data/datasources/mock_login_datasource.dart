import 'package:bam_wallet/features/login/data/models/user_model.dart';

class MockLoginDataSource {
  // Mock user database
  static const Map<String, String> _mockUsers = {
    'test@example.com': 'password123',
    'user@example.com': 'password456',
  };

  Future<UserModel> login(String email, String password) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    // Check if user exists
    if (!_mockUsers.containsKey(email)) {
      throw Exception('401');
    }

    // Check password
    if (_mockUsers[email] != password) {
      throw Exception('401');
    }

    // Return mock user
    return UserModel(
      id: email.hashCode.toString(),
      email: email,
      name: email.split('@')[0].toUpperCase(),
      token: 'mock_token_${DateTime.now().millisecondsSinceEpoch}',
    );
  }
}
