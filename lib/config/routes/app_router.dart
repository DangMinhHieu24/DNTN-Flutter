// ============================================================================
// FILE: lib/config/routes/app_router.dart
// MỤC ĐÍCH: Centralized routing configuration với go_router
// ĐƯỢC GỌI TỪ: lib/main.dart (MaterialApp.router)
// ============================================================================

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:features/auth/presentation/pages/splash_page.dart';
import 'package:features/auth/presentation/pages/login_page.dart';
import 'package:features/auth/presentation/pages/register_page.dart';
import 'package:features/auth/presentation/pages/home_page.dart';

/// Centralized routing configuration với go_router
/// Quản lý tất cả navigation trong app
class AppRouter {
  AppRouter._();

  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';

  /// GoRouter instance - được dùng trong MaterialApp.router
  /// File: lib/main.dart → MaterialApp.router(routerConfig: AppRouter.router)
  static final GoRouter router = GoRouter(
    initialLocation: splash,
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: splash,
        name: 'splash',
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: const SplashPage(),
        ),
      ),

      GoRoute(
        path: login,
        name: 'login',
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: const LoginPage(),
        ),
      ),


      GoRoute(
        path: register,
        name: 'register',
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: const RegisterPage(),
        ),
      ),

      // ──────────────────────────────────────────────────────────────────
      // ROUTE 4: Home Screen (Protected - cần auth)
      // ──────────────────────────────────────────────────────────────────
      GoRoute(
        path: home,
        name: 'home',
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          // File: packages/features/lib/auth/presentation/pages/home_page.dart
          // Nhiệm vụ:
          // 1. Hiển thị nội dung chính của app
          // 2. Có logout button
          // 3. Listen AuthUnauthenticated state để navigate về Login
          child: const HomePage(),
        ),
      ),
    ],

    // ========================================================================
    // ERROR HANDLER - Xử lý khi route không tồn tại
    // ========================================================================
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Page not found: ${state.uri.path}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              // Navigate về splash khi gặp lỗi
              onPressed: () => context.go(splash),
              child: const Text('Go to Home'),
            ),
          ],
        ),
      ),
    ),
  );
}

// ============================================================================
// CÁCH SỬ DỤNG GO_ROUTER:
// ============================================================================
//
// 1. NAVIGATE ĐẾN ROUTE MỚI (replace current):
//    context.go('/home');
//    → Thay thế route hiện tại bằng /home
//    → Không thể back về route cũ
//
// 2. PUSH ROUTE MỚI (thêm vào stack):
//    context.push('/register');
//    → Thêm /register vào navigation stack
//    → Có thể back về route trước
//
// 3. POP ROUTE (quay lại):
//    context.pop();
//    → Quay lại route trước đó trong stack
//
// 4. NAVIGATE VỚI PARAMETERS:
//    context.go('/profile/123');
//    → Cần define route: '/profile/:id'
//
// 5. CHECK CURRENT ROUTE:
//    GoRouter.of(context).location
//    → Trả về path hiện tại (vd: '/home')
//
// ============================================================================
// NAVIGATION FLOW TRONG APP:
// ============================================================================
//
// App Start:
//   / (Splash) → Check auth
//     ├─→ /home (nếu có session)
//     └─→ /login (nếu chưa login)
//
// Login Flow:
//   /login → User login → /home
//
// Register Flow:
//   /login → Click "Đăng ký" → /register → Register success → /home
//
// Logout Flow:
//   /home → Click logout → /login
//
// ============================================================================

