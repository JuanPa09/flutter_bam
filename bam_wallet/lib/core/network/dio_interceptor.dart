import 'package:dio/dio.dart';
import 'package:bam_wallet/core/local_storage.dart';
import 'package:bam_wallet/core/consts.dart';

class DioInterceptor extends Interceptor {
  final Dio dio;

  DioInterceptor({required this.dio});

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Agregar token a cada solicitud (si existe)
    final token = LocalStorage().prefs.getString(Consts.sessionTokenKey);
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Manejar errores de autenticación
    if (err.response?.statusCode == 401) {
      print('Authentication error: Token expirado o inválido');
    } else {
      print('API error: ${err.message}');
    }

    super.onError(err, handler);
  }
}
