// ============================================================================
// FILE: packages/features/lib/auth/presentation/bloc/auth_state.dart
// MỤC ĐÍCH: Định nghĩa các States (Trạng thái UI) trong Auth feature
// PATTERN: BLoC Pattern - States represent UI state
// ============================================================================

import 'package:equatable/equatable.dart';
import '../../domain/entities/user_entity.dart';

// ============================================================================
// BASE CLASS: AuthState
// ============================================================================
// Abstract class - không thể tạo instance trực tiếp
// Tất cả auth states phải extend class này
// Equatable giúp so sánh states (tránh rebuild không cần thiết)
abstract class AuthState extends Equatable {
  const AuthState();

  // Override props để Equatable có thể compare
  // Empty list vì base class không có properties
  @override
  List<Object?> get props => [];
}

// ============================================================================
// STATE 1: AuthInitial - Trạng thái ban đầu
// ============================================================================
/// Khi nào: Khi AuthBloc mới được tạo (initial state)
/// UI hiển thị: Không có gì (hoặc placeholder)
/// 
/// Được emit từ: AuthBloc constructor
/// super(const AuthInitial()) trong auth_bloc.dart
/// 
/// Chuyển sang state khác khi:
/// - User dispatch event (Login, Register, AuthCheck, Logout)
class AuthInitial extends AuthState {
  const AuthInitial();
  
  // Không có properties nên props = empty list
}

// ============================================================================
// STATE 2: AuthLoading - Đang xử lý request
// ============================================================================
/// Khi nào: Khi đang gọi API hoặc xử lý logic
/// UI hiển thị: Loading indicator (CircularProgressIndicator)
/// 
/// Được emit từ:
/// - AuthBloc._onLoginRequested() (đầu function)
/// - AuthBloc._onRegisterRequested() (đầu function)
/// - AuthBloc._onLogoutRequested() (đầu function)
/// - AuthBloc._onAuthCheckRequested() (đầu function)
/// 
/// Chuyển sang state khác khi:
/// - Request thành công → AuthSuccess
/// - Request thất bại → AuthError
/// - Logout hoàn tất → AuthUnauthenticated
/// 
/// Ví dụ trong UI:
/// ```dart
/// BlocBuilder<AuthBloc, AuthState>(
///   builder: (context, state) {
///     if (state is AuthLoading) {
///       return CircularProgressIndicator();
///     }
///     // ...
///   }
/// )
/// ```
class AuthLoading extends AuthState {
  const AuthLoading();
  
  // Không có properties nên props = empty list
}

// ============================================================================
// STATE 3: AuthSuccess - Xác thực thành công, có thông tin user
// ============================================================================
/// Khi nào: Sau khi login/register thành công, hoặc tìm thấy session
/// UI hiển thị: Navigate đến HomePage, hiển thị user info
/// 
/// Được emit từ:
/// - AuthBloc._onLoginRequested() (khi login thành công)
/// - AuthBloc._onRegisterRequested() (khi register thành công)
/// - AuthBloc._onAuthCheckRequested() (khi tìm thấy session)
/// 
/// Properties:
/// - user: UserEntity - Thông tin user (id, name, phone, email, etc.)
/// 
/// Ví dụ trong UI:
/// ```dart
/// BlocListener<AuthBloc, AuthState>(
///   listener: (context, state) {
///     if (state is AuthSuccess) {
///       // Navigate to Home
///       context.go('/home');
///       
///       // Hoặc hiển thị user info
///       print('Welcome ${state.user.name}');
///     }
///   }
/// )
/// ```
class AuthSuccess extends AuthState {
  final UserEntity user;  // Thông tin user đã login

  const AuthSuccess({required this.user});

  // Override props để Equatable compare dựa trên user
  // Nếu user thay đổi → state mới → UI rebuild
  @override
  List<Object?> get props => [user];
}

// ============================================================================
// STATE 4: AuthError - Xác thực thất bại, có message lỗi
// ============================================================================
/// Khi nào: Khi login/register/logout thất bại
/// UI hiển thị: SnackBar với error message
/// 
/// Được emit từ:
/// - AuthBloc._onLoginRequested() (khi login fail)
/// - AuthBloc._onRegisterRequested() (khi register fail)
/// 
/// Properties:
/// - message: String - Thông báo lỗi từ server hoặc local
/// 
/// Các loại lỗi thường gặp:
/// - "Số điện thoại hoặc mật khẩu không đúng" (401)
/// - "Số điện thoại đã được đăng ký" (422)
/// - "Không có kết nối mạng" (NetworkFailure)
/// - "Lỗi máy chủ, vui lòng thử lại" (500)
/// 
/// Ví dụ trong UI:
/// ```dart
/// BlocListener<AuthBloc, AuthState>(
///   listener: (context, state) {
///     if (state is AuthError) {
///       ScaffoldMessenger.of(context).showSnackBar(
///         SnackBar(content: Text(state.message)),
///       );
///     }
///   }
/// )
/// ```
class AuthError extends AuthState {
  final String message;  // Thông báo lỗi

  const AuthError({required this.message});

  // Override props để Equatable compare dựa trên message
  @override
  List<Object> get props => [message];
}

// ============================================================================
// STATE 5: AuthUnauthenticated - Chưa đăng nhập / Đã đăng xuất
// ============================================================================
/// Khi nào: 
/// - Khi user chưa login
/// - Sau khi logout thành công
/// - Khi không tìm thấy session (AuthCheck fail)
/// 
/// UI hiển thị: Navigate đến LoginPage
/// 
/// Được emit từ:
/// - AuthBloc._onLogoutRequested() (sau khi logout)
/// - AuthBloc._onAuthCheckRequested() (khi không có session)
/// 
/// Ví dụ trong UI:
/// ```dart
/// BlocListener<AuthBloc, AuthState>(
///   listener: (context, state) {
///     if (state is AuthUnauthenticated) {
///       // Navigate to Login
///       context.go('/login');
///     }
///   }
/// )
/// ```
class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
  
  // Không có properties nên props = empty list
}

// ============================================================================
// STATE TRANSITION DIAGRAM
// ============================================================================
//
// AuthInitial (app start)
//   ↓ dispatch AuthCheckRequested
// AuthLoading
//   ├─→ AuthSuccess (có session) → navigate to Home
//   └─→ AuthUnauthenticated (không có session) → navigate to Login
//
// AuthUnauthenticated (ở LoginPage)
//   ↓ dispatch LoginRequested
// AuthLoading
//   ├─→ AuthSuccess (login thành công) → navigate to Home
//   └─→ AuthError (login thất bại) → show error, stay at Login
//
// AuthSuccess (ở HomePage)
//   ↓ dispatch LogoutRequested
// AuthLoading
//   └─→ AuthUnauthenticated → navigate to Login
//
// ============================================================================
// CÁCH SỬ DỤNG STATES TRONG UI:
// ============================================================================
//
// 1. BLOCLISTENER - Cho side effects (navigation, snackbar):
//    BlocListener<AuthBloc, AuthState>(
//      listener: (context, state) {
//        if (state is AuthSuccess) {
//          context.go('/home');
//        } else if (state is AuthError) {
//          showSnackBar(state.message);
//        }
//      },
//      child: YourWidget(),
//    )
//
// 2. BLOCBUILDER - Cho UI rebuild:
//    BlocBuilder<AuthBloc, AuthState>(
//      builder: (context, state) {
//        if (state is AuthLoading) {
//          return CircularProgressIndicator();
//        }
//        if (state is AuthError) {
//          return Text('Error: ${state.message}');
//        }
//        return LoginForm();
//      }
//    )
//
// 3. BLOCCONSUMER - Kết hợp cả listener và builder:
//    BlocConsumer<AuthBloc, AuthState>(
//      listener: (context, state) {
//        // Side effects
//      },
//      builder: (context, state) {
//        // UI
//      }
//    )
//
// ============================================================================
// TẠI SAO DÙNG STATES?
// ============================================================================
//
// 1. SINGLE SOURCE OF TRUTH:
//    - UI chỉ phụ thuộc vào state
//    - State thay đổi → UI tự động update
//
// 2. PREDICTABLE:
//    - Biết chính xác UI sẽ như thế nào với mỗi state
//    - Dễ debug: xem state hiện tại là gì
//
// 3. TESTABLE:
//    - Test: emit state → verify UI
//    - Không cần test UI logic phức tạp
//
// 4. MAINTAINABLE:
//    - Thêm state mới không ảnh hưởng code cũ
//    - Thay đổi UI dễ dàng
//
// ============================================================================
