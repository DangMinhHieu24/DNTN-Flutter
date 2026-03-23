import 'package:get_it/get_it.dart';
import '../../auth/di/auth_injection.dart';

/// Service Locator instance
final sl = GetIt.instance;

/// Initialize tất cả dependencies
Future<void> initializeDependencies() async {
  // Initialize Auth module dependencies
  AuthInjection.init(sl);

  // Có thể thêm các module khác ở đây
  // Example:
  // CourseInjection.init(sl);
  // ProfileInjection.init(sl);
}
