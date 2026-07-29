import 'package:chefaa/core/routes/app_routes_names.dart';
import 'package:chefaa/core/routes/routes.dart';
import 'package:chefaa/core/services/storage_service.dart';
import 'package:dio/dio.dart';

class AuthInterceptor extends Interceptor {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await StorageService.getToken();

    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 403 || err.response?.statusCode == 401) {
      final responseData = err.response?.data;
      final message = responseData is Map ? responseData['message'] : null;
      if (message == 'Invalid or expired token') {
        await StorageService.clearAll();

        AppRouter.router.go(AppRoutesNames.login);
      }
    }
    super.onError(err, handler);
  }
}
