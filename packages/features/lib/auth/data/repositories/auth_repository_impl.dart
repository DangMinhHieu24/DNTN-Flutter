import 'package:dartz/dartz.dart';
import 'package:core/error/exceptions.dart';
import 'package:core/error/failures.dart';
import 'package:core/network/api_client.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_datasource.dart';
import '../datasources/auth_remote_datasource.dart';

/// Implementation của AuthRepository.
/// Kết nối giữa Domain Layer và Data Layer.
/// Xử lý business logic liên quan đến data (caching, error handling, etc.)
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;
  final ApiClient apiClient;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.apiClient,
  });

  @override
  Future<Either<Failure, UserEntity>> login({
    required String phone,
    required String password,
  }) async {
    try {
      // Gọi API đăng nhập
      final authResponse = await remoteDataSource.login(
        phone: phone,
        password: password,
      );

      // Lưu access token vào ApiClient để sử dụng cho các request tiếp theo
      apiClient.setAuthToken(authResponse.accessToken);

      // Cache user data và tokens vào local storage
      await Future.wait([
        localDataSource.cacheUser(authResponse.user),
        localDataSource.saveAccessToken(authResponse.accessToken),
        if (authResponse.refreshToken != null)
          localDataSource.saveRefreshToken(authResponse.refreshToken!),
      ]);

      // Trả về UserEntity (Domain layer)
      return Right(authResponse.user.toEntity());
    } on AuthException catch (e) {
      return Left(AuthFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Đã xảy ra lỗi: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> register({
    required String name,
    required String phone,
    required String password,
  }) async {
    try {
      // Gọi API đăng ký
      final authResponse = await remoteDataSource.register(
        name: name,
        phone: phone,
        password: password,
      );

      // Lưu access token vào ApiClient
      apiClient.setAuthToken(authResponse.accessToken);

      // Cache user data và tokens
      await Future.wait([
        localDataSource.cacheUser(authResponse.user),
        localDataSource.saveAccessToken(authResponse.accessToken),
        if (authResponse.refreshToken != null)
          localDataSource.saveRefreshToken(authResponse.refreshToken!),
      ]);

      return Right(authResponse.user.toEntity());
    } on AuthException catch (e) {
      return Left(AuthFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Đã xảy ra lỗi: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      // Gọi API logout (nếu cần invalidate token trên server)
      try {
        await remoteDataSource.logout();
      } catch (_) {
        // Ignore lỗi từ server, vẫn clear local data
      }

      // Clear tất cả auth data từ local storage
      await localDataSource.clearAuthData();

      // Clear token từ ApiClient
      apiClient.clearAuthToken();

      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(CacheFailure(message: 'Đăng xuất thất bại: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, UserEntity?>> getCurrentUser() async {
    try {
      // Thử lấy từ cache trước
      final cachedUser = await localDataSource.getCachedUser();
      
      if (cachedUser != null) {
        // Kiểm tra xem có access token không
        final accessToken = await localDataSource.getAccessToken();
        
        if (accessToken != null && accessToken.isNotEmpty) {
          // Set token vào ApiClient
          apiClient.setAuthToken(accessToken);
          
          // Có thể thêm logic để verify token với server
          // hoặc refresh nếu token sắp hết hạn
          
          return Right(cachedUser.toEntity());
        }
      }

      // Nếu không có cache hoặc không có token, trả về null
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(CacheFailure(
        message: 'Không thể lấy thông tin user: ${e.toString()}',
      ));
    }
  }

  /// Helper method để refresh token khi access token hết hạn
  /// Có thể được gọi từ interceptor hoặc khi nhận 401 response
  Future<Either<Failure, void>> refreshAccessToken() async {
    try {
      final refreshToken = await localDataSource.getRefreshToken();
      
      if (refreshToken == null || refreshToken.isEmpty) {
        return const Left(AuthFailure(message: 'Không có refresh token'));
      }

      final authResponse = await remoteDataSource.refreshToken(refreshToken);

      // Update tokens
      apiClient.setAuthToken(authResponse.accessToken);
      await Future.wait([
        localDataSource.saveAccessToken(authResponse.accessToken),
        if (authResponse.refreshToken != null)
          localDataSource.saveRefreshToken(authResponse.refreshToken!),
      ]);

      return const Right(null);
    } on AuthException catch (e) {
      // Token refresh failed, clear auth data
      await localDataSource.clearAuthData();
      apiClient.clearAuthToken();
      return Left(AuthFailure(message: e.message));
    } catch (e) {
      return Left(AuthFailure(message: 'Refresh token thất bại'));
    }
  }
}
