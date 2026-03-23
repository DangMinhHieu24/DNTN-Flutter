import 'package:dartz/dartz.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../models/user_model.dart';

/// Implementation của AuthRepository
/// Hiện tại dùng fake data để test, sau này sẽ connect với API thật
class AuthRepositoryImpl implements AuthRepository {
  // Fake database để lưu users
  final List<UserModel> _fakeUsers = [];
  UserModel? _currentUser;

  @override
  Future<Either<String, User>> login({
    required String phone,
    required String password,
  }) async {
    try {
      // Giả lập network delay
      await Future.delayed(const Duration(seconds: 2));

      // Tìm user trong fake database
      final user = _fakeUsers.firstWhere(
        (u) => u.phone == phone,
        orElse: () => throw Exception('User not found'),
      );

      // Trong thực tế, sẽ check password hash
      // Hiện tại giả sử password luôn đúng nếu tìm thấy user
      _currentUser = user;

      return Right(user);
    } catch (e) {
      // Trả về error message
      if (e.toString().contains('User not found')) {
        return const Left('Số điện thoại chưa được đăng ký');
      }
      return Left('Đăng nhập thất bại: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, User>> register({
    required String name,
    required String phone,
    required String password,
  }) async {
    try {
      // Giả lập network delay
      await Future.delayed(const Duration(seconds: 2));

      // Check xem phone đã tồn tại chưa
      final existingUser = _fakeUsers.where((u) => u.phone == phone);
      if (existingUser.isNotEmpty) {
        return const Left('Số điện thoại đã được đăng ký');
      }

      // Tạo user mới
      final newUser = UserModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        phone: phone,
        createdAt: DateTime.now(),
      );

      // Lưu vào fake database
      _fakeUsers.add(newUser);
      _currentUser = newUser;

      return Right(newUser);
    } catch (e) {
      return Left('Đăng ký thất bại: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, void>> logout() async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      _currentUser = null;
      return const Right(null);
    } catch (e) {
      return Left('Đăng xuất thất bại: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, User?>> getCurrentUser() async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      return Right(_currentUser);
    } catch (e) {
      return Left('Không thể lấy thông tin user: ${e.toString()}');
    }
  }
}
