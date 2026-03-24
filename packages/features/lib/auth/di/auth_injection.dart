import 'package:get_it/get_it.dart';
import '../domain/usecases/login_usecase.dart';
import '../domain/usecases/register_usecase.dart';
import '../presentation/bloc/auth_bloc.dart';

/// Khởi tạo dependency injection cho tầng Auth.
/// Được gọi từ app-level injection_container.dart.
class AuthInjection {
  AuthInjection._();

  static void init(GetIt sl) {
    // ── BLoC ──────────────────────────────────────
    sl.registerFactory(
      () => AuthBloc(
        loginUseCase: sl(),
        registerUseCase: sl(),
      ),
    );

    // ── Use Cases ─────────────────────────────────
    sl.registerLazySingleton(() => LoginUseCase(sl()));
    sl.registerLazySingleton(() => RegisterUseCase(sl()));

    // ── Repository & DataSource ────────────────────
    // TODO (Phase 2): Wire AuthRepositoryImpl và AuthRemoteDataSource
    // sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()));
    // sl.registerLazySingleton<AuthRemoteDataSource>(() => AuthRemoteDataSourceImpl(sl()));
  }
}
