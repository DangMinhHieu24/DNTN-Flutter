// ============================================================================
// FILE: lib/di/injection_container.dart
// MỤC ĐÍCH: Dependency Injection container cho toàn bộ app
// PATTERN: Service Locator với GetIt
// ============================================================================

import 'package:get_it/get_it.dart';
import 'package:features/auth/di/auth_injection.dart';

// ============================================================================
// SERVICE LOCATOR - Singleton instance của GetIt
// ============================================================================
// sl = Service Locator
// Dùng để lấy dependencies ở bất kỳ đâu trong app
// Ví dụ: sl<AuthBloc>(), sl<LoginUseCase>()
final sl = GetIt.instance;

// ============================================================================
// INITIALIZE DEPENDENCIES - Setup tất cả dependencies
// ============================================================================
// Được gọi từ: lib/main.dart (trong main function)
// Mục đích: Đăng ký tất cả dependencies vào GetIt container
Future<void> initializeDependencies() async {
  // BƯỚC 1: Khởi tạo Auth feature dependencies
  // File: packages/features/lib/auth/di/auth_injection.dart
  // Đăng ký:
  //   - AuthBloc (Factory - tạo mới mỗi lần gọi)
  //   - UseCases (Singleton - dùng chung 1 instance)
  //   - Repository (Singleton)
  //   - DataSources (Singleton)
  //   - ApiClient (Singleton)
  //   - SharedPreferences (Singleton)
  await AuthInjection.init(sl);
  
  // TODO: Thêm các feature khác ở đây khi mở rộng
  // await CourseInjection.init(sl);
  // await ProfileInjection.init(sl);
}

// ============================================================================
// CÁCH SỬ DỤNG SERVICE LOCATOR:
// ============================================================================
// 1. Đăng ký dependency (trong init function):
//    sl.registerFactory(() => AuthBloc(...));
//    sl.registerLazySingleton(() => LoginUseCase(...));
//
// 2. Lấy dependency (ở bất kỳ đâu):
//    final authBloc = sl<AuthBloc>();
//    final loginUseCase = sl<LoginUseCase>();
//
// 3. Factory vs Singleton:
//    - Factory: Tạo instance mới mỗi lần gọi (dùng cho BLoC)
//    - Singleton: Dùng chung 1 instance (dùng cho UseCase, Repository)
// ============================================================================
