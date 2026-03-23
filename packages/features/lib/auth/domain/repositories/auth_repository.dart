import 'package:dartz/dartz.dart';
import '../entities/user.dart';

/// Abstract Repository - Định nghĩa contract cho auth operations
/// Data layer sẽ implement interface này
abstract class AuthRepository {
  /// Đăng nhập với phone và password
  /// Returns: Either<String, User>
  /// - Left: Error message
  /// - Right: User object
  Future<Either<String, User>> login({
    required String phone,
    required String password,
  });

  /// Đăng ký tài khoản mới
  /// Returns: Either<String, User>
  /// - Left: Error message
  /// - Right: User object
  Future<Either<String, User>> register({
    required String name,
    required String phone,
    required String password,
  });

  /// Đăng xuất
  Future<Either<String, void>> logout();

  /// Lấy thông tin user hiện tại (nếu đã login)
  Future<Either<String, User?>> getCurrentUser();
}
