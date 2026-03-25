import 'package:dio/dio.dart';
import '../error/exceptions.dart';

/// Centralized API Client sử dụng Dio.
/// Xử lý tất cả HTTP requests và error handling.
class ApiClient {
  final Dio _dio;
  
  ApiClient({
    required String baseUrl,
    Duration? connectTimeout,
    Duration? receiveTimeout,
  }) : _dio = Dio(
          BaseOptions(
            baseUrl: baseUrl,
            connectTimeout: connectTimeout ?? const Duration(seconds: 30),
            receiveTimeout: receiveTimeout ?? const Duration(seconds: 30),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          ),
        ) {
    _setupInterceptors();
  }

  /// Setup interceptors cho logging và error handling
  void _setupInterceptors() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // Log request (chỉ trong development)
          // ignore: avoid_print
          print('🌐 REQUEST[${options.method}] => ${options.path}');
          // ignore: avoid_print
          print('📦 Data: ${options.data}');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          // Log response (chỉ trong development)
          // ignore: avoid_print
          print('✅ RESPONSE[${response.statusCode}] => ${response.requestOptions.path}');
          return handler.next(response);
        },
        onError: (error, handler) {
          // Log error (chỉ trong development)
          // ignore: avoid_print
          print('❌ ERROR[${error.response?.statusCode}] => ${error.requestOptions.path}');
          // ignore: avoid_print
          print('📛 Message: ${error.message}');
          return handler.next(error);
        },
      ),
    );
  }

  /// Set authorization token cho các request tiếp theo
  void setAuthToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  /// Clear authorization token
  void clearAuthToken() {
    _dio.options.headers.remove('Authorization');
  }

  /// GET request
  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
      );
      return response;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// POST request
  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return response;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// PUT request
  Future<Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return response;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// DELETE request
  Future<Response> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return response;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Xử lý DioException và convert sang custom Exception
  Exception _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const NetworkException(
          message: 'Kết nối timeout, vui lòng thử lại',
        );

      case DioExceptionType.connectionError:
        return const NetworkException(
          message: 'Không có kết nối mạng',
        );

      case DioExceptionType.badResponse:
        return _handleResponseError(error.response);

      case DioExceptionType.cancel:
        return const ServerException(message: 'Request đã bị hủy');

      default:
        return ServerException(
          message: error.message ?? 'Đã xảy ra lỗi không xác định',
        );
    }
  }

  /// Xử lý lỗi từ response
  Exception _handleResponseError(Response? response) {
    final statusCode = response?.statusCode ?? 0;
    final data = response?.data;

    // Lấy error message từ response
    String message = 'Đã xảy ra lỗi';
    if (data is Map<String, dynamic>) {
      message = data['message']?.toString() ?? 
                data['error']?.toString() ?? 
                data['msg']?.toString() ?? 
                message;
    }

    // Xử lý theo status code
    switch (statusCode) {
      case 400:
        return ServerException(
          message: message.isEmpty ? 'Yêu cầu không hợp lệ' : message,
          statusCode: statusCode,
        );
      case 401:
        return AuthException(
          message: message.isEmpty ? 'Phiên đăng nhập hết hạn' : message,
        );
      case 403:
        return AuthException(
          message: message.isEmpty ? 'Không có quyền truy cập' : message,
        );
      case 404:
        return ServerException(
          message: message.isEmpty ? 'Không tìm thấy dữ liệu' : message,
          statusCode: statusCode,
        );
      case 422:
        return ServerException(
          message: message.isEmpty ? 'Dữ liệu không hợp lệ' : message,
          statusCode: statusCode,
        );
      case 500:
      case 502:
      case 503:
        return ServerException(
          message: 'Lỗi máy chủ, vui lòng thử lại sau',
          statusCode: statusCode,
        );
      default:
        return ServerException(
          message: message,
          statusCode: statusCode,
        );
    }
  }
}
