import 'package:equatable/equatable.dart';
import '../../domain/entities/user.dart';

/// Base class cho tất cả Auth States
abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

/// State: Trạng thái ban đầu
class AuthInitial extends AuthState {
  const AuthInitial();
}

/// State: Đang xử lý (loading)
class AuthLoading extends AuthState {
  const AuthLoading();
}

/// State: Đăng nhập/đăng ký thành công
class AuthSuccess extends AuthState {
  final User user;

  const AuthSuccess(this.user);

  @override
  List<Object?> get props => [user];
}

/// State: Có lỗi xảy ra
class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);

  @override
  List<Object?> get props => [message];
}

/// State: User chưa đăng nhập (unauthenticated)
class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

/// State: Đăng xuất thành công
class AuthLoggedOut extends AuthState {
  const AuthLoggedOut();
}
