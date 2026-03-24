import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

/// Yêu cầu đăng nhập
class LoginRequested extends AuthEvent {
  final String phone;
  final String password;

  const LoginRequested({
    required this.phone,
    required this.password,
  });

  @override
  List<Object> get props => [phone, password];
}

/// Yêu cầu đăng ký tài khoản
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
  List<Object> get props => [name, phone, password];
}

/// Yêu cầu đăng xuất
class LogoutRequested extends AuthEvent {
  const LogoutRequested();
}

/// Kiểm tra session khi app khởi động
class AuthCheckRequested extends AuthEvent {
  const AuthCheckRequested();
}
