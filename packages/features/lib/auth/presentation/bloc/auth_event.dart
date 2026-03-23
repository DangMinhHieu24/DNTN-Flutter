import 'package:equatable/equatable.dart';

/// Base class cho tất cả Auth Events
abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

/// Event: User request đăng nhập
class LoginRequested extends AuthEvent {
  final String phone;
  final String password;

  const LoginRequested({
    required this.phone,
    required this.password,
  });

  @override
  List<Object?> get props => [phone, password];
}

/// Event: User request đăng ký
class RegisterRequested extends AuthEvent {
  final String name;
  final String phone;
  final String password;

  const RegisterRequested({
    required this.name,
    required this.phone,
    required this.password,
  });

  @override
  List<Object?> get props => [name, phone, password];
}

/// Event: User request đăng xuất
class LogoutRequested extends AuthEvent {
  const LogoutRequested();
}

/// Event: Check xem user đã login chưa (khi app start)
class CheckAuthStatus extends AuthEvent {
  const CheckAuthStatus();
}
