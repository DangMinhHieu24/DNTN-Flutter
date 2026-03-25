// ============================================================================
// FILE: packages/features/lib/auth/presentation/pages/splash_page.dart
// MỤC ĐÍCH: Splash Screen - Kiểm tra auth state khi app khởi động
// ĐƯỢC GỌI TỪ: lib/config/routes/app_router.dart (initial route: /)
// ============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:core/theme/app_colors.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

/// Splash Screen - Kiểm tra auth state khi app khởi động
/// Nếu đã login → navigate to Home
/// Nếu chưa login → navigate to Login
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  // ========================================================================
  // LIFECYCLE: initState - Được gọi 1 lần khi widget được tạo
  // ========================================================================
  @override
  void initState() {
    super.initState();
    
    // BƯỚC 1: Dispatch AuthCheckRequested event ngay khi page load
    // File event: packages/features/lib/auth/presentation/bloc/auth_event.dart
    // AuthBloc sẽ nhận event này và xử lý
    // File bloc: packages/features/lib/auth/presentation/bloc/auth_bloc.dart
    context.read<AuthBloc>().add(const AuthCheckRequested());
    
    // ========================================================================
    // LUỒNG XỬ LÝ SAU KHI DISPATCH EVENT:
    // ========================================================================
    // 1. AuthBloc nhận AuthCheckRequested event
    // 2. AuthBloc gọi _onAuthCheckRequested handler
    // 3. Handler gọi GetCurrentUserUseCase
    //    File: packages/features/lib/auth/domain/usecases/get_current_user_usecase.dart
    // 4. UseCase gọi AuthRepository.getCurrentUser()
    //    File: packages/features/lib/auth/data/repositories/auth_repository_impl.dart
    // 5. Repository gọi AuthLocalDataSource.getCachedUser()
    //    File: packages/features/lib/auth/data/datasources/auth_local_datasource.dart
    // 6. LocalDataSource đọc user từ SharedPreferences
    // 7. Nếu có user + token:
    //    → Repository set token vào ApiClient
    //    → Trả về Right(UserEntity)
    //    → AuthBloc emit AuthSuccess(user)
    // 8. Nếu không có user hoặc token:
    //    → Trả về Right(null)
    //    → AuthBloc emit AuthUnauthenticated
    // 9. BlocListener (ở dưới) nhận state và navigate
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      // ========================================================================
      // BLOC LISTENER - Lắng nghe state changes và thực hiện side effects
      // ========================================================================
      // Tại sao dùng BlocListener? 
      // - Để thực hiện navigation (side effect)
      // - Không rebuild UI khi state thay đổi
      listener: (context, state) {
        // CASE 1: User đã login (có session)
        // File state: packages/features/lib/auth/presentation/bloc/auth_state.dart
        if (state is AuthSuccess) {
          // Navigate đến Home page
          // File: packages/features/lib/auth/presentation/pages/home_page.dart
          // Dùng context.go() để replace current route (không thể back về splash)
          context.go('/home');
        } 
        // CASE 2: User chưa login (không có session)
        else if (state is AuthUnauthenticated) {
          // Navigate đến Login page
          // File: packages/features/lib/auth/presentation/pages/login_page.dart
          context.go('/login');
        }
        // CASE 3: AuthLoading → giữ nguyên splash screen (hiển thị loading)
        // CASE 4: AuthError → cũng navigate to Login (coi như chưa login)
        else if (state is AuthError) {
          context.go('/login');
        }
      },
      
      // ========================================================================
      // UI - Splash Screen
      // ========================================================================
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // ──────────────────────────────────────────────────────────
              // App Logo
              // ──────────────────────────────────────────────────────────
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.psychology_alt_rounded,
                  size: 64,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 32),
              
              // ──────────────────────────────────────────────────────────
              // App Name
              // ──────────────────────────────────────────────────────────
              const Text(
                'AI Learning Coach',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: AppColors.onSurface,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 8),
              
              // ──────────────────────────────────────────────────────────
              // Tagline
              // ──────────────────────────────────────────────────────────
              Text(
                'Mindful Curator',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.onSurfaceVariant.withValues(alpha: 0.6),
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 48),
              
              // ──────────────────────────────────────────────────────────
              // Loading Indicator - Hiển thị khi đang check auth
              // ──────────────────────────────────────────────────────────
              const SizedBox(
                width: 32,
                height: 32,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// TÓM TẮT LUỒNG HOẠT ĐỘNG:
// ============================================================================
//
// 1. App start → AppRouter load SplashPage (initial route: /)
// 2. SplashPage.initState() → dispatch AuthCheckRequested
// 3. AuthBloc xử lý event:
//    a. Gọi GetCurrentUserUseCase
//    b. UseCase gọi Repository.getCurrentUser()
//    c. Repository đọc cache từ LocalDataSource
//    d. Nếu có user + token → emit AuthSuccess
//    e. Nếu không có → emit AuthUnauthenticated
// 4. BlocListener nhận state:
//    a. AuthSuccess → context.go('/home')
//    b. AuthUnauthenticated → context.go('/login')
// 5. User được navigate đến đúng màn hình
//
// ============================================================================
// KẾT NỐI VỚI CÁC FILE KHÁC:
// ============================================================================
//
// INPUT (Nhận từ):
//   - AppRouter: Load page này làm initial route
//   - AuthBloc: Cung cấp qua BlocProvider trong main.dart
//
// OUTPUT (Gọi đến):
//   - AuthBloc: Dispatch AuthCheckRequested event
//   - AppRouter: Navigate đến /home hoặc /login
//
// DEPENDENCIES:
//   - flutter_bloc: BlocListener để listen state changes
//   - go_router: context.go() để navigate
//   - core/theme: AppColors cho styling
//   - auth_bloc: AuthBloc, AuthEvent, AuthState
//
// ============================================================================

