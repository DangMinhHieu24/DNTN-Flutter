import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

/// AuthBloc - Quản lý state và logic cho authentication
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc({required this.authRepository}) : super(const AuthInitial()) {
    // Đăng ký handlers cho từng event
    on<LoginRequested>(_onLoginRequested);
    on<RegisterRequested>(_onRegisterRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<CheckAuthStatus>(_onCheckAuthStatus);
  }

  /// Handler cho LoginRequested event
  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    // 1. Emit loading state
    emit(const AuthLoading());

    // 2. Gọi repository để login
    final result = await authRepository.login(
      phone: event.phone,
      password: event.password,
    );

    // 3. Xử lý kết quả
    result.fold(
      // Left: Error
      (error) => emit(AuthError(error)),
      // Right: Success
      (user) => emit(AuthSuccess(user)),
    );
  }

  /// Handler cho RegisterRequested event
  Future<void> _onRegisterRequested(
    RegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    // 1. Emit loading state
    emit(const AuthLoading());

    // 2. Gọi repository để register
    final result = await authRepository.register(
      name: event.name,
      phone: event.phone,
      password: event.password,
    );

    // 3. Xử lý kết quả
    result.fold(
      // Left: Error
      (error) => emit(AuthError(error)),
      // Right: Success
      (user) => emit(AuthSuccess(user)),
    );
  }

  /// Handler cho LogoutRequested event
  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    // 1. Emit loading state
    emit(const AuthLoading());

    // 2. Gọi repository để logout
    final result = await authRepository.logout();

    // 3. Xử lý kết quả
    result.fold(
      // Left: Error
      (error) => emit(AuthError(error)),
      // Right: Success
      (_) => emit(const AuthLoggedOut()),
    );
  }

  /// Handler cho CheckAuthStatus event
  Future<void> _onCheckAuthStatus(
    CheckAuthStatus event,
    Emitter<AuthState> emit,
  ) async {
    // 1. Emit loading state
    emit(const AuthLoading());

    // 2. Check xem user đã login chưa
    final result = await authRepository.getCurrentUser();

    // 3. Xử lý kết quả
    result.fold(
      // Left: Error
      (error) => emit(const AuthUnauthenticated()),
      // Right: Success
      (user) {
        if (user != null) {
          emit(AuthSuccess(user));
        } else {
          emit(const AuthUnauthenticated());
        }
      },
    );
  }
}
