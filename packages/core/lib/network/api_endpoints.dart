/// Centralized API endpoints configuration.
/// Giúp dễ dàng quản lý và thay đổi endpoints.
class ApiEndpoints {
  ApiEndpoints._();

  // Base URL - thay đổi theo môi trường
  // 🔧 DEVELOPMENT: Dùng mock server local
  // Android Emulator: 10.0.2.2
  // iOS Simulator: localhost
  // Thiết bị thật: IP máy tính (vd: 192.168.1.100)
  static const String baseUrl = 'http://10.0.2.2:3000';
  
  // 🚀 PRODUCTION: Uncomment khi có backend thật
  // static const String baseUrl = 'https://api.example.com/v1';
  
  // Auth endpoints
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String logout = '/auth/logout';
  static const String refreshToken = '/auth/refresh';
  static const String me = '/auth/me';
  
  // User endpoints
  static const String users = '/users';
  static String userById(String id) => '/users/$id';
  static const String updateProfile = '/users/profile';
  
  // Có thể thêm các endpoints khác ở đây
  // static const String courses = '/courses';
  // static const String lessons = '/lessons';
}
