import 'package:dio/dio.dart';

class DioInterceptor extends Interceptor {
  final Dio dio;

  DioInterceptor({required this.dio});

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Agregar token a cada solicitud (si existe)
    // const token = await _getToken(); // obten tu token guardado
    // options.headers['Authorization'] = 'Bearer $token';

    print('Solicitud: ${options.method} ${options.path}');
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print('Respuesta: ${response.statusCode} ${response.requestOptions.path}');
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    print('Error: ${err.message}');

    // Manejar errores de autenticación
    if (err.response?.statusCode == 401) {
      // Token expirado - aquí puedes renovar el token
      print('Token expirado, necesita re-login');
    }

    super.onError(err, handler);
  }
}
