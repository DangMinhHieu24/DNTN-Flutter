/// Exception ném ra từ tầng Data (datasource).
/// Sẽ được bắt tại Repository và chuyển thành Failure.

class ServerException implements Exception {
  final String message;
  final int? statusCode;
  const ServerException({this.message = 'Server error', this.statusCode});
}

class NetworkException implements Exception {
  final String message;
  const NetworkException({this.message = 'No internet connection'});
}

class CacheException implements Exception {
  final String message;
  const CacheException({this.message = 'Cache error'});
}

class AuthException implements Exception {
  final String message;
  const AuthException({required this.message});
}
