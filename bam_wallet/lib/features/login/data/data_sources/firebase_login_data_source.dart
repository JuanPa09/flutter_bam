import 'package:bam_wallet/features/login/data/data_sources/login_data_source.dart';
import 'package:bam_wallet/features/login/data/models/user_password_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';

class FirebaseLoginDataSource implements LoginDataSource {
  FirebaseLoginDataSource({FirebaseAuth? firebaseAuth})
    : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  final FirebaseAuth _firebaseAuth;

  @override
  Future<UserModel> loginWithEmailAndPassword(
    UserPasswordModel loginModel,
  ) async {
    try {
      final response = await _signInWithRetry(
        loginModel.username,
        loginModel.password,
      );

      final idToken = await response.user?.getIdToken();

      return UserModel(
        id: response.user?.uid ?? '',
        email: response.user?.email ?? '',
        firstName: response.user?.displayName ?? '',
        lastName: '',
        accessToken: idToken ?? '',
        username: response.user?.email ?? '',
        gender: '',
        image: response.user?.photoURL ?? '',
      );
    } on FirebaseAuthException catch (e) {
      throw Exception(_getErrorCode(e));
    } catch (e) {
      throw Exception('error_unexpected');
    }
  }

  /// Intenta autenticar con reintentos en caso de que Firebase no esté listo
  Future<UserCredential> _signInWithRetry(
    String email,
    String password, {
    int maxAttempts = 3,
    int delayMs = 1000,
  }) async {
    for (int attempt = 1; attempt <= maxAttempts; attempt++) {
      try {
        return await _firebaseAuth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      } on FirebaseAuthException catch (e) {
        // Si es un error de configuración, reintenta
        if (e.code == 'configuration-not-found' && attempt < maxAttempts) {
          await Future.delayed(Duration(milliseconds: delayMs));
          delayMs *= 2;
          continue;
        }
        // Para otros errores, lanza inmediatamente
        rethrow;
      }
    }

    throw FirebaseAuthException(
      code: 'configuration-not-found',
      message: 'Firebase configuration timeout after $maxAttempts attempts',
    );
  }

  /// Mapea el código de error de Firebase a un código de localización
  String _getErrorCode(FirebaseAuthException error) {
    switch (error.code) {
      case 'user-not-found':
        return 'error_firebase_user_not_found';
      case 'wrong-password':
        return 'error_firebase_wrong_password';
      case 'invalid-email':
      case 'user-disabled':
      case 'too-many-requests':
      case 'network-request-failed':
      case 'invalid-credential':
      default:
        return 'error_firebase_invalid_credentials';
    }
  }
}
