import 'package:core/network/api_client.dart';
import 'package:core/network/api_endpoints.dart';
import 'package:core/error/exceptions.dart';
import '../models/auth_response_model.dart';

/// Abstract interface cho Auth Remote Data Source.
/// Định nghĩa các phương thức giao tiếp với API.
abstract class AuthRemoteDataSource {
  /// Đăng nhập với số điện thoại và mật khẩu
  Future<AuthResponseModel> login({
    required String phone,
    required String password,
  });

  /// Đăng ký tài khoản mới
  Future<AuthResponseModel> register({
    required String name,
    required String phone,
    required String password,
  });

  /// Đăng xuất
  Future<void> logout();

  /// Lấy thông tin user hiện tại từ server
  Future<AuthResponseModel> getCurrentUser();

  /// Refresh access token
  Future<AuthResponseModel> refreshToken(String refreshToken);
}

/// Implementation của AuthRemoteDataSource sử dụng ApiClient.
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient apiClient;

  AuthRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<AuthResponseModel> login({
    required String phone,
    required String password,
  }) async {
    try {
      final response = await apiClient.post(
        ApiEndpoints.login,
        data: {
          'phone': phone,
          'password': password,
        },
      );

      // Kiểm tra response data
      if (response.data == null) {
        throw const ServerException(message: 'Response data is null');
      }

      // Parse response
      final data = response.data is Map<String, dynamic>
          ? response.data as Map<String, dynamic>
          : {'data': response.data};

      return AuthResponseModel.fromJson(data);
    } on ServerException {
      rethrow;
    } on NetworkException {
      rethrow;
    } on AuthException {
      rethrow;
    } catch (e) {
      throw ServerException(message: 'Đăng nhập thất bại: ${e.toString()}');
    }
  }

  @override
  Future<AuthResponseModel> register({
    required String name,
    required String phone,
    required String password,
  }) async {
    try {
      final response = await apiClient.post(
        ApiEndpoints.register,
        data: {
          'name': name,
          'phone': phone,
          'password': password,
        },
      );

      if (response.data == null) {
        throw const ServerException(message: 'Response data is null');
      }

      final data = response.data is Map<String, dynamic>
          ? response.data as Map<String, dynamic>
          : {'data': response.data};

      return AuthResponseModel.fromJson(data);
    } on ServerException {
      rethrow;
    } on NetworkException {
      rethrow;
    } on AuthException {
      rethrow;
    } catch (e) {
      throw ServerException(message: 'Đăng ký thất bại: ${e.toString()}');
    }
  }

  @override
  Future<void> logout() async {
    try {
      await apiClient.post(ApiEndpoints.logout);
    } on ServerException {
      rethrow;
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw ServerException(message: 'Đăng xuất thất bại: ${e.toString()}');
    }
  }

  @override
  Future<AuthResponseModel> getCurrentUser() async {
    try {
      final response = await apiClient.get(ApiEndpoints.me);

      if (response.data == null) {
        throw const ServerException(message: 'Response data is null');
      }

      final data = response.data is Map<String, dynamic>
          ? response.data as Map<String, dynamic>
          : {'data': response.data};

      return AuthResponseModel.fromJson(data);
    } on ServerException {
      rethrow;
    } on NetworkException {
      rethrow;
    } on AuthException {
      rethrow;
    } catch (e) {
      throw ServerException(
        message: 'Lấy thông tin user thất bại: ${e.toString()}',
      );
    }
  }

  @override
  Future<AuthResponseModel> refreshToken(String refreshToken) async {
    try {
      final response = await apiClient.post(
        ApiEndpoints.refreshToken,
        data: {'refresh_token': refreshToken},
      );

      if (response.data == null) {
        throw const ServerException(message: 'Response data is null');
      }

      final data = response.data is Map<String, dynamic>
          ? response.data as Map<String, dynamic>
          : {'data': response.data};

      return AuthResponseModel.fromJson(data);
    } on ServerException {
      rethrow;
    } on NetworkException {
      rethrow;
    } on AuthException {
      rethrow;
    } catch (e) {
      throw ServerException(
        message: 'Refresh token thất bại: ${e.toString()}',
      );
    }
  }
}
