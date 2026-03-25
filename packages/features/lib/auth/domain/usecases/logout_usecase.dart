import 'package:dartz/dartz.dart';
import 'package:core/error/failures.dart';
import 'package:core/usecases/usecase.dart';
import '../repositories/auth_repository.dart';

/// Use Case: Đăng xuất
/// Xóa session, tokens và navigate về login
class LogoutUseCase extends UseCase<void, NoParams> {
  final AuthRepository repository;

  LogoutUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) {
    return repository.logout();
  }
}
