import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:core/error/failures.dart';
import 'package:core/usecases/usecase.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

/// Use Case: Đăng ký tài khoản mới
class RegisterUseCase extends UseCase<UserEntity, RegisterParams> {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(RegisterParams params) {
    return repository.register(
      name: params.name,
      phone: params.phone,
      password: params.password,
    );
  }
}

class RegisterParams extends Equatable {
  final String name;
  final String phone;
  final String password;

  const RegisterParams({
    required this.name,
    required this.phone,
    required this.password,
  });

  @override
  List<Object> get props => [name, phone, password];
}
