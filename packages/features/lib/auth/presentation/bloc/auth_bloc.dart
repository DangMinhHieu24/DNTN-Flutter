// ============================================================================
// FILE: packages/features/lib/auth/presentation/bloc/auth_bloc.dart
// MỤC ĐÍCH: BLoC (Business Logic Component) - Xử lý business logic và state management
// PATTERN: BLoC Pattern - Nhận Events, xử lý logic, emit States
// ============================================================================

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/usecases/usecase.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/get_current_user_usecase.dart';
import 'auth_event.dart';
import 'auth_state.dart';

// ============================================================================
// AUTHBLOC - Trung tâm xử lý logic của Auth feature
// ============================================================================
/// Nhiệm vụ:
/// 1. Nhận Events từ UI (LoginRequested, RegisterRequested, etc.)
/// 2. Gọi UseCases để xử lý business logic
/// 3. Emit States mới cho UI (AuthSuccess, AuthError, etc.)
/// 
/// Được provide bởi: BlocProvider trong main.dart
/// Được inject từ: GetIt (sl<AuthBloc>())
/// File DI: packages/features/lib/auth/di/auth_injection.dart
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  // ========================================================================
  // DEPENDENCIES - UseCases được inject qua constructor
  // ========================================================================
  final LoginUseCase loginUseCase;                    // Xử lý login logic
  final RegisterUseCase registerUseCase;              // Xử lý register logic
  final LogoutUseCase logoutUseCase;                  // Xử lý logout logic
  final GetCurrentUserUseCase getCurrentUserUseCase;  // Lấy user từ cache

  // ========================================================================
  // CONSTRUCTOR
  // ========================================================================
  AuthBloc({
    required this.loginUseCase,
    required this.registerUseCase,
    required this.logoutUseCase,
    required this.getCurrentUserUseCase,
  }) : super(const AuthInitial()) {  // Initial state = AuthInitial
    // Đăng ký event handlers
    // Khi nhận LoginRequested event → gọi _onLoginRequested
    on<LoginRequested>(_onLoginRequested);
    
    // Khi nhận RegisterRequested event → gọi _onRegisterRequested
    on<RegisterRequested>(_onRegisterRequested);
    
    // Khi nhận LogoutRequested event → gọi _onLogoutRequested
    on<LogoutRequested>(_onLogoutRequested);
    
    // Khi nhận AuthCheckRequested event → gọi _onAuthCheckRequested
    on<AuthCheckRequested>(_onAuthCheckRequested);
  }

  // ========================================================================
  // HANDLER 1: _onLoginRequested - Xử lý đăng nhập
  // ========================================================================
  /// Được gọi khi: UI dispatch LoginRequested event
  /// File gọi: packages/features/lib/auth/presentation/pages/login_page.dart
  /// 
  /// Flow:
  /// 1. Emit AuthLoading (show loading indicator)
  /// 2. Gọi LoginUseCase với phone + password
  /// 3. UseCase gọi Repository → DataSource → API
  /// 4. Nhận kết quả: Either<Failure, UserEntity>
  /// 5. Nếu success → emit AuthSuccess(user)
  /// 6. Nếu failure → emit AuthError(message)
  Future<void> _onLoginRequested(
    LoginRequested event,      // Event chứa phone + password
    Emitter<AuthState> emit,   // Emitter để emit states
  ) async {
    // BƯỚC 1: Emit loading state
    // UI sẽ hiển thị loading indicator
    emit(const AuthLoading());

    // BƯỚC 2: Gọi LoginUseCase
    // File: packages/features/lib/auth/domain/usecases/login_usecase.dart
    // Truyền LoginParams(phone, password)
    final result = await loginUseCase(
      LoginParams(phone: event.phone, password: event.password),
    );

    // BƯỚC 3: Xử lý kết quả với Either pattern (Dartz)
    // result là Either<Failure, UserEntity>
    // fold() xử lý cả 2 cases: failure (left) và success (right)
    result.fold(
      // CASE 1: Failure (left side)
      // failure có type: ServerFailure, NetworkFailure, AuthFailure, etc.
      // File: packages/core/lib/error/failures.dart
      (failure) => emit(AuthError(message: failure.message)),
      
      // CASE 2: Success (right side)
      // user có type: UserEntity
      // File: packages/features/lib/auth/domain/entities/user_entity.dart
      (user) => emit(AuthSuccess(user: user)),
    );
    
    // UI sẽ nhận state mới (AuthSuccess hoặc AuthError)
    // BlocListener sẽ navigate hoặc show error
  }

  // ========================================================================
  // HANDLER 2: _onRegisterRequested - Xử lý đăng ký
  // ========================================================================
  /// Được gọi khi: UI dispatch RegisterRequested event
  /// File gọi: packages/features/lib/auth/presentation/pages/register_page.dart
  /// 
  /// Flow tương tự login, nhưng dùng RegisterUseCase
  Future<void> _onRegisterRequested(
    RegisterRequested event,   // Event chứa name + phone + password
    Emitter<AuthState> emit,
  ) async {
    // BƯỚC 1: Emit loading
    emit(const AuthLoading());

    // BƯỚC 2: Gọi RegisterUseCase
    // File: packages/features/lib/auth/domain/usecases/register_usecase.dart
    final result = await registerUseCase(
      RegisterParams(
        name: event.name,
        phone: event.phone,
        password: event.password,
      ),
    );

    // BƯỚC 3: Xử lý kết quả
    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (user) => emit(AuthSuccess(user: user)),
    );
  }

  // ========================================================================
  // HANDLER 3: _onLogoutRequested - Xử lý đăng xuất
  // ========================================================================
  /// Được gọi khi: UI dispatch LogoutRequested event
  /// File gọi: packages/features/lib/auth/presentation/pages/home_page.dart
  /// 
  /// Flow:
  /// 1. Emit AuthLoading
  /// 2. Gọi LogoutUseCase
  /// 3. UseCase gọi Repository.logout()
  /// 4. Repository clear cache + tokens + API client
  /// 5. Emit AuthUnauthenticated (dù success hay fail)
  /// 6. UI navigate về LoginPage
  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    // BƯỚC 1: Emit loading
    emit(const AuthLoading());

    // BƯỚC 2: Gọi LogoutUseCase
    // File: packages/features/lib/auth/domain/usecases/logout_usecase.dart
    // NoParams vì logout không cần parameters
    final result = await logoutUseCase(NoParams());

    // BƯỚC 3: Xử lý kết quả
    // Đặc biệt: Ngay cả khi logout fail (vd: API error),
    // vẫn emit AuthUnauthenticated để clear local state
    result.fold(
      (failure) {
        // Logout fail nhưng vẫn clear local state
        // Lý do: Không muốn user bị stuck nếu API lỗi
        emit(const AuthUnauthenticated());
      },
      (_) => emit(const AuthUnauthenticated()),
    );
    
    // UI sẽ navigate về LoginPage
  }

  // ========================================================================
  // HANDLER 4: _onAuthCheckRequested - Kiểm tra session khi app start
  // ========================================================================
  /// Được gọi khi: SplashPage.initState()
  /// File gọi: packages/features/lib/auth/presentation/pages/splash_page.dart
  /// 
  /// Flow:
  /// 1. Emit AuthLoading (show splash screen với loading)
  /// 2. Gọi GetCurrentUserUseCase
  /// 3. UseCase gọi Repository.getCurrentUser()
  /// 4. Repository đọc user từ LocalDataSource (SharedPreferences)
  /// 5. Nếu có user + token → emit AuthSuccess → navigate to Home
  /// 6. Nếu không có → emit AuthUnauthenticated → navigate to Login
  Future<void> _onAuthCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    // BƯỚC 1: Emit loading
    emit(const AuthLoading());

    // BƯỚC 2: Gọi GetCurrentUserUseCase
    // File: packages/features/lib/auth/domain/usecases/get_current_user_usecase.dart
    final result = await getCurrentUserUseCase(NoParams());

    // BƯỚC 3: Xử lý kết quả
    result.fold(
      // CASE 1: Failure (cache error, etc.)
      // → Coi như chưa login
      (failure) => emit(const AuthUnauthenticated()),
      
      // CASE 2: Success
      // user có thể null nếu không có session
      (user) {
        if (user != null) {
          // Có user + token → đã login trước đó
          emit(AuthSuccess(user: user));
        } else {
          // Không có user → chưa login
          emit(const AuthUnauthenticated());
        }
      },
    );
    
    // UI (SplashPage) sẽ navigate dựa trên state
  }
}

// ============================================================================
// LUỒNG DỮ LIỆU TRONG BLOC:
// ============================================================================
//
// UI (Page)
//   ↓ dispatch event
// AuthBloc.add(event)
//   ↓ route to handler
// _onXxxRequested(event, emit)
//   ↓ emit loading
// emit(AuthLoading)
//   ↓ gọi use case
// await useCase(params)
//   ↓ use case gọi repository
// repository.xxx()
//   ↓ repository gọi data sources
// remoteDataSource / localDataSource
//   ↓ trả về Either<Failure, Data>
// result.fold(...)
//   ↓ emit state mới
// emit(AuthSuccess) hoặc emit(AuthError)
//   ↓ UI nhận state
// BlocListener / BlocBuilder rebuild
//
// ============================================================================
// TẠI SAO DÙNG BLOC?
// ============================================================================
//
// 1. SEPARATION OF CONCERNS:
//    - UI chỉ dispatch events và listen states
//    - BLoC xử lý tất cả business logic
//    - Dễ test, dễ maintain
//
// 2. REACTIVE:
//    - State thay đổi → UI tự động update
//    - Không cần setState() thủ công
//
// 3. PREDICTABLE:
//    - Event → Handler → State
//    - Luồng dữ liệu rõ ràng, dễ debug
//
// 4. TESTABLE:
//    - Test BLoC: dispatch event → verify state
//    - Không cần mock UI
//
// 5. REUSABLE:
//    - Nhiều UI có thể dùng chung 1 BLoC
//    - Logic không bị duplicate
//
// ============================================================================
// CÁCH DEBUG BLOC:
// ============================================================================
//
// 1. THÊM PRINT STATEMENTS:
//    print('📥 Event: $event');
//    print('📤 State: $state');
//
// 2. DÙNG BLOC OBSERVER:
//    class MyBlocObserver extends BlocObserver {
//      @override
//      void onEvent(Bloc bloc, Object? event) {
//        print('Event: $event');
//      }
//      @override
//      void onTransition(Bloc bloc, Transition transition) {
//        print('Transition: $transition');
//      }
//    }
//
// 3. DÙNG FLUTTER DEVTOOLS:
//    - Xem event history
//    - Xem state changes
//    - Time travel debugging
//
// ============================================================================
