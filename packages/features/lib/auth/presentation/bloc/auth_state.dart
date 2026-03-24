import 'package:equatable/equatable.dart';
import '../../domain/entities/user_entity.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

/// Trạng thái khởi tạo
class AuthInitial extends AuthState {
  const AuthInitial();
}

/// Đang xử lý (loading)
class AuthLoading extends AuthState {
  const AuthLoading();
}

/// Xác thực thành công — có thông tin user
class AuthSuccess extends AuthState {
  final UserEntity user;

  const AuthSuccess({required this.user});

  @override
  List<Object?> get props => [user];
}

/// Xác thực thất bại — có message lỗi
class AuthError extends AuthState {
  final String message;

  const AuthError({required this.message});

  @override
  List<Object> get props => [message];
}

/// Người dùng chưa đăng nhập / đã đăng xuất
class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}
