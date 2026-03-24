import 'package:dartz/dartz.dart';
import 'package:core/error/failures.dart';
import '../entities/user_entity.dart';

/// Abstract interface cho Auth Repository.
/// Tầng Domain chỉ biết đến interface này, không biết implement cụ thể.
abstract class AuthRepository {
  /// Đăng nhập bằng số điện thoại và mật khẩu.
  /// Trả về [UserEntity] khi thành công, [Failure] khi thất bại.
  Future<Either<Failure, UserEntity>> login({
    required String phone,
    required String password,
  });

  /// Đăng ký tài khoản mới.
  Future<Either<Failure, UserEntity>> register({
    required String name,
    required String phone,
    required String password,
  });

  /// Đăng xuất.
  Future<Either<Failure, void>> logout();

  /// Lấy thông tin user hiện tại (từ cache/session).
  Future<Either<Failure, UserEntity?>> getCurrentUser();
}
