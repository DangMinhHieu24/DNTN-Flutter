import 'package:equatable/equatable.dart';

/// Base class cho tất cả Failure trong app.
/// Dùng làm phần Left của Either<Failure, T>.
abstract class Failure extends Equatable {
  final String message;
  const Failure({required this.message});

  @override
  List<Object> get props => [message];
}

/// Lỗi từ server / API
class ServerFailure extends Failure {
  const ServerFailure({super.message = 'Lỗi máy chủ, vui lòng thử lại.'});
}

/// Lỗi kết nối mạng
class NetworkFailure extends Failure {
  const NetworkFailure({super.message = 'Không có kết nối mạng.'});
}

/// Lỗi đọc/ghi bộ nhớ cục bộ
class CacheFailure extends Failure {
  const CacheFailure({super.message = 'Lỗi lưu trữ dữ liệu cục bộ.'});
}

/// Lỗi xác thực (sai email/password, token hết hạn, ...)
class AuthFailure extends Failure {
  const AuthFailure({required super.message});
}

/// Lỗi không tìm thấy dữ liệu
class NotFoundFailure extends Failure {
  const NotFoundFailure({super.message = 'Không tìm thấy dữ liệu.'});
}
