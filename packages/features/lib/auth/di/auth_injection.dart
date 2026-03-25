// ============================================================================
// FILE: packages/features/lib/auth/di/auth_injection.dart
// MỤC ĐÍCH: Dependency Injection cho Auth feature
// ĐƯỢC GỌI TỪ: lib/di/injection_container.dart
// ============================================================================

import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:core/network/api_client.dart';
import 'package:core/network/api_endpoints.dart';
import '../domain/repositories/auth_repository.dart';
import '../domain/usecases/login_usecase.dart';
import '../domain/usecases/register_usecase.dart';
import '../domain/usecases/logout_usecase.dart';
import '../domain/usecases/get_current_user_usecase.dart';
import '../data/repositories/auth_repository_impl.dart';
import '../data/datasources/auth_remote_datasource.dart';
import '../data/datasources/auth_local_datasource.dart';
import '../presentation/bloc/auth_bloc.dart';

/// Khởi tạo dependency injection cho tầng Auth.
/// Được gọi từ: lib/di/injection_container.dart
class AuthInjection {
  
  AuthInjection._();

  static Future<void> init(GetIt sl) async {
    // ========================================================================
  
    sl.registerFactory(
      () => AuthBloc(
      
        loginUseCase: sl(),              // → LoginUseCase
        registerUseCase: sl(),           // → RegisterUseCase
        logoutUseCase: sl(),             // → LogoutUseCase
        getCurrentUserUseCase: sl(),     // → GetCurrentUserUseCase
      ),
    );

    sl.registerLazySingleton(() => LoginUseCase(sl()));
  
    sl.registerLazySingleton(() => RegisterUseCase(sl()));

    sl.registerLazySingleton(() => LogoutUseCase(sl()));
    
    /
    sl.registerLazySingleton(() => GetCurrentUserUseCase(sl()));

    /
    sl.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(
       
        remoteDataSource: sl(),  // → AuthRemoteDataSource (API calls)
        localDataSource: sl(),   // → AuthLocalDataSource (Cache)
        apiClient: sl(),         // → ApiClient (HTTP client)
      ),
    );

    sl.registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(
        apiClient: sl(),  // → ApiClient để gọi API
      ),
    );

    // AuthLocalDataSource - Quản lý local storage (SharedPreferences)
    // File: packages/features/lib/auth/data/datasources/auth_local_datasource.dart
    // Nhiệm vụ: Cache user data, lưu/đọc tokens
    sl.registerLazySingleton<AuthLocalDataSource>(
      () => AuthLocalDataSourceImpl(
        sharedPreferences: sl(),  // → SharedPreferences
      ),
    );

    // ========================================================================
    // LAYER 5: EXTERNAL - Third-party libraries
    // ========================================================================
    
    // ApiClient - HTTP client dùng Dio
    // File: packages/core/lib/network/api_client.dart
    // Nhiệm vụ: Gửi HTTP requests, xử lý errors, manage tokens
    // Check isRegistered để tránh đăng ký 2 lần (vì có thể dùng chung với features khác)
    if (!sl.isRegistered<ApiClient>()) {
      sl.registerLazySingleton<ApiClient>(
        () => ApiClient(
          baseUrl: ApiEndpoints.baseUrl,  // Base URL từ config
        ),
      );
    }

    // SharedPreferences - Local storage của Flutter
    // Nhiệm vụ: Lưu trữ key-value pairs (tokens, user data)
    // Phải await vì getInstance() là async
    if (!sl.isRegistered<SharedPreferences>()) {
      final sharedPreferences = await SharedPreferences.getInstance();
      sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
    }
  }
}

// ============================================================================
// DEPENDENCY GRAPH - Ai phụ thuộc vào ai?
// ============================================================================
//
// AuthBloc
//   ├─→ LoginUseCase
//   │     └─→ AuthRepository
//   │           ├─→ AuthRemoteDataSource
//   │           │     └─→ ApiClient
//   │           ├─→ AuthLocalDataSource
//   │           │     └─→ SharedPreferences
//   │           └─→ ApiClient
//   ├─→ RegisterUseCase
//   │     └─→ AuthRepository (same as above)
//   ├─→ LogoutUseCase
//   │     └─→ AuthRepository (same as above)
//   └─→ GetCurrentUserUseCase
//         └─→ AuthRepository (same as above)
//
// ============================================================================
// LUỒNG DỮ LIỆU KHI LOGIN:
// ============================================================================
// 1. UI dispatch LoginRequested event
// 2. AuthBloc nhận event
// 3. AuthBloc gọi LoginUseCase.call()
// 4. LoginUseCase gọi AuthRepository.login()
// 5. AuthRepositoryImpl gọi AuthRemoteDataSource.login()
// 6. AuthRemoteDataSource gọi ApiClient.post()
// 7. ApiClient gửi HTTP request đến server
// 8. Server trả về response
// 9. AuthRemoteDataSource parse response thành AuthResponseModel
// 10. AuthRepositoryImpl lưu user vào AuthLocalDataSource
// 11. AuthRepositoryImpl set token vào ApiClient
// 12. AuthRepositoryImpl trả về Either<Failure, UserEntity>
// 13. LoginUseCase trả về kết quả cho AuthBloc
// 14. AuthBloc emit AuthSuccess state
// 15. UI nhận state và navigate đến Home
// ============================================================================
