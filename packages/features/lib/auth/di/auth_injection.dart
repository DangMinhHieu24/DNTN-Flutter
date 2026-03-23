import 'package:get_it/get_it.dart';
import '../data/repositories/auth_repository_impl.dart';
import '../domain/repositories/auth_repository.dart';
import '../presentation/bloc/auth_bloc.dart';

/// Dependency Injection cho Auth module
/// Đăng ký tất cả dependencies vào GetIt service locator
class AuthInjection {
  static void init(GetIt sl) {
    // Repository
    // Đăng ký AuthRepository với implementation là AuthRepositoryImpl
    // LazySingleton: Chỉ tạo 1 instance duy nhất khi được gọi lần đầu
    sl.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(),
    );

    // BLoC
    // Đăng ký AuthBloc
    // Factory: Tạo instance mới mỗi khi được gọi
    sl.registerFactory(
      () => AuthBloc(authRepository: sl()),
    );
  }
}
