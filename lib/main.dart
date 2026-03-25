// ============================================================================
// FILE: lib/main.dart
// MỤC ĐÍCH: Điểm khởi đầu của ứng dụng Flutter
// ============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/theme/app_theme.dart';
import 'package:features/auth/presentation/bloc/auth_bloc.dart';
import 'config/routes/app_router.dart';
import 'di/injection_container.dart';

// ============================================================================
// MAIN FUNCTION - Hàm đầu tiên được chạy khi app khởi động
// ============================================================================
void main() async {
  // Đảm bảo Flutter framework đã sẵn sàng trước khi chạy async code
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDependencies();
  runApp(const MyApp());
}

// ============================================================================
// MyApp - Widget gốc của ứng dụng
// ============================================================================
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<AuthBloc>(),
      child: MaterialApp.router(
        title: 'AI Learning Coach',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        routerConfig: AppRouter.router,
      ),
    );
  }
}
