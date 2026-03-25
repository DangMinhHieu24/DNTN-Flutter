// ============================================================================
// FILE: packages/features/lib/auth/presentation/bloc/auth_event.dart
// MỤC ĐÍCH: Định nghĩa các Events (User Actions) trong Auth feature
// PATTERN: BLoC Pattern - Events represent user intentions
// ============================================================================

import 'package:equatable/equatable.dart';

// ============================================================================
// BASE CLASS: AuthEvent
// ============================================================================
// Abstract class - không thể tạo instance trực tiếp
// Tất cả auth events phải extend class này
// Equatable giúp so sánh events (cần cho BLoC)
abstract class AuthEvent extends Equatable {
  const AuthEvent();

  // Override props để Equatable có thể compare
  // Empty list vì base class không có properties
  @override
  List<Object?> get props => [];
}

// ============================================================================
// EVENT 1: LoginRequested - User muốn đăng nhập
// ============================================================================
/// Được dispatch từ: LoginPage (khi user click "Đăng nhập")
/// File: packages/features/lib/auth/presentation/pages/login_page.dart
/// 
/// Xử lý bởi: AuthBloc._onLoginRequested()
/// File: packages/features/lib/auth/presentation/bloc/auth_bloc.dart
/// 
/// Flow:
/// 1. User nhập phone + password
/// 2. Click button "Đăng nhập"
/// 3. LoginPage dispatch: context.read<AuthBloc>().add(LoginRequested(...))
/// 4. AuthBloc nhận event và xử lý
class LoginRequested extends AuthEvent {
  final String phone;      // Số điện thoại user nhập
  final String password;   // Mật khẩu user nhập

  const LoginRequested({
    required this.phone,
    required this.password,
  });

  // Override props để Equatable compare dựa trên phone và password
  // Nếu 2 events có cùng phone + password → coi như giống nhau
  @override
  List<Object> get props => [phone, password];
}

// ============================================================================
// EVENT 2: RegisterRequested - User muốn đăng ký tài khoản mới
// ============================================================================
/// Được dispatch từ: RegisterPage (khi user click "Đăng ký ngay")
/// File: packages/features/lib/auth/presentation/pages/register_page.dart
/// 
/// Xử lý bởi: AuthBloc._onRegisterRequested()
/// File: packages/features/lib/auth/presentation/bloc/auth_bloc.dart
/// 
/// Flow:
/// 1. User nhập name + phone + password + confirm password
/// 2. Validate form
/// 3. Click button "Đăng ký ngay"
/// 4. RegisterPage dispatch: context.read<AuthBloc>().add(RegisterRequested(...))
/// 5. AuthBloc nhận event và xử lý
class RegisterRequested extends AuthEvent {
  final String name;       // Họ tên user nhập
  final String phone;      // Số điện thoại user nhập
  final String password;   // Mật khẩu user nhập

  const RegisterRequested({
    required this.name,
    required this.phone,
    required this.password,
  });

  // Override props để Equatable compare
  @override
  List<Object> get props => [name, phone, password];
}

// ============================================================================
// EVENT 3: LogoutRequested - User muốn đăng xuất
// ============================================================================
/// Được dispatch từ: HomePage (khi user click logout button)
/// File: packages/features/lib/auth/presentation/pages/home_page.dart
/// 
/// Xử lý bởi: AuthBloc._onLogoutRequested()
/// File: packages/features/lib/auth/presentation/bloc/auth_bloc.dart
/// 
/// Flow:
/// 1. User ở HomePage
/// 2. Click logout button (icon ở AppBar)
/// 3. Show confirmation dialog
/// 4. User confirm logout
/// 5. HomePage dispatch: context.read<AuthBloc>().add(LogoutRequested())
/// 6. AuthBloc xử lý logout (clear cache, tokens)
/// 7. Navigate về LoginPage
class LogoutRequested extends AuthEvent {
  const LogoutRequested();
  
  // Không có properties nên props = empty list
}

// ============================================================================
// EVENT 4: AuthCheckRequested - Kiểm tra session khi app khởi động
// ============================================================================
/// Được dispatch từ: SplashPage (trong initState)
/// File: packages/features/lib/auth/presentation/pages/splash_page.dart
/// 
/// Xử lý bởi: AuthBloc._onAuthCheckRequested()
/// File: packages/features/lib/auth/presentation/bloc/auth_bloc.dart
/// 
/// Flow:
/// 1. App start → AppRouter load SplashPage
/// 2. SplashPage.initState() được gọi
/// 3. SplashPage dispatch: context.read<AuthBloc>().add(AuthCheckRequested())
/// 4. AuthBloc check session từ cache
/// 5. Nếu có session → emit AuthSuccess → navigate to Home
/// 6. Nếu không có → emit AuthUnauthenticated → navigate to Login
/// 
/// Mục đích: Tự động login nếu user đã login trước đó
class AuthCheckRequested extends AuthEvent {
  const AuthCheckRequested();
  
  // Không có properties nên props = empty list
}

// ============================================================================
// CÁCH SỬ DỤNG EVENTS:
// ============================================================================
//
// 1. DISPATCH EVENT TỪ UI:
//    context.read<AuthBloc>().add(LoginRequested(
//      phone: '0123456789',
//      password: 'password123',
//    ));
//
// 2. AUTHBLOC NHẬN EVENT:
//    - BLoC tự động route event đến đúng handler
//    - LoginRequested → _onLoginRequested()
//    - RegisterRequested → _onRegisterRequested()
//    - LogoutRequested → _onLogoutRequested()
//    - AuthCheckRequested → _onAuthCheckRequested()
//
// 3. HANDLER XỬ LÝ:
//    - Gọi UseCase tương ứng
//    - Nhận kết quả (Either<Failure, Success>)
//    - Emit state mới (AuthSuccess, AuthError, etc.)
//
// 4. UI NHẬN STATE MỚI:
//    - BlocListener/BlocBuilder rebuild
//    - Hiển thị UI tương ứng với state
//
// ============================================================================
// TẠI SAO DÙNG EVENTS?
// ============================================================================
//
// 1. SEPARATION OF CONCERNS:
//    - UI chỉ dispatch events (nói "tôi muốn làm gì")
//    - BLoC xử lý logic (quyết định "làm thế nào")
//    - UI không biết về business logic
//
// 2. TESTABILITY:
//    - Dễ test: dispatch event → verify state
//    - Không cần mock UI
//
// 3. MAINTAINABILITY:
//    - Thay đổi logic không ảnh hưởng UI
//    - Thêm event mới dễ dàng
//
// 4. TRACEABILITY:
//    - Dễ debug: xem event nào được dispatch
//    - Dễ log user actions
//
// ============================================================================
