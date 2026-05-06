import 'package:bam_wallet/core/environment/env.dart';

abstract class ApiConsts {
  static String apiUrlLogin = Env.get('apiUrlLogin');

  // Endpoints Entrega 2
  static String base = Env.get('apiUrl');
  static String loginEndpoint = "$base/auth/login";
  static String usersEndpoint = "$base/users";
}
