/// ============================================================================
/// FILE: packages/features/lib/auth/auth.dart
/// MỤC ĐÍCH: Public API của Auth Feature (Barrel File)
/// NGUYÊN TẮC: Chỉ export những gì cần thiết cho bên ngoài sử dụng.
/// Ẩn đi các chi tiết thực thi (Data Layer, Internal Widgets).
/// ============================================================================

library auth;

// ─────────────────────────────────────────────────────────────────────────────
// 1. DOMAIN LAYER (Public Interfaces & Entities)
// ─────────────────────────────────────────────────────────────────────────────
// Các module khác cần UserEntity để hiển thị thông tin user.
export 'domain/entities/user_entity.dart';
// Export interface repository (không export implementation).
export 'domain/repositories/auth_repository.dart';
// Export UseCases nếu các feature khác cần gọi logic của Auth.
export 'domain/usecases/login_usecase.dart';
export 'domain/usecases/register_usecase.dart';
export 'domain/usecases/logout_usecase.dart';
export 'domain/usecases/get_current_user_usecase.dart';

// ─────────────────────────────────────────────────────────────────────────────
// 2. PRESENTATION LAYER (State Management & Pages)
// ─────────────────────────────────────────────────────────────────────────────
// Export BLoC để main app có thể cung cấp Auth state cho toàn bộ cây widget.
export 'presentation/bloc/auth_bloc.dart';
export 'presentation/bloc/auth_event.dart';
export 'presentation/bloc/auth_state.dart';

// Export các Pages để AppRouter có thể định nghĩa routes.
export 'presentation/pages/splash_page.dart';
export 'presentation/pages/login_page.dart';
export 'presentation/pages/register_page.dart';
export 'presentation/pages/home_page.dart';

// ─────────────────────────────────────────────────────────────────────────────
// 3. DEPENDENCY INJECTION
// ─────────────────────────────────────────────────────────────────────────────
// Export AuthInjection để khởi tạo dependencies tại main.dart.
export 'di/auth_injection.dart';