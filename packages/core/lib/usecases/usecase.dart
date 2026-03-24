import 'package:dartz/dartz.dart';
import '../error/failures.dart';

/// Abstract base class cho tất cả Use Case.
///
/// [T]      — kiểu dữ liệu trả về khi thành công
/// [Params] — tham số đầu vào (dùng [NoParams] nếu không cần)
abstract class UseCase<T, Params> {
  Future<Either<Failure, T>> call(Params params);
}

/// Dùng khi Use Case không cần tham số đầu vào.
class NoParams {}
