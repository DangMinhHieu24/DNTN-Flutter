import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:core/error/exceptions.dart';
import '../models/user_model.dart';

/// Abstract interface cho Auth Local Data Source.
/// Quản lý việc lưu trữ và đọc dữ liệu auth từ local storage.
abstract class AuthLocalDataSource {
  /// Lưu user data vào local storage
  Future<void> cacheUser(UserModel user);

  /// Lấy cached user data
  Future<UserModel?> getCachedUser();

  /// Xóa cached user data
  Future<void> clearCachedUser();

  /// Lưu access token
  Future<void> saveAccessToken(String token);

  /// Lấy access token
  Future<String?> getAccessToken();

  /// Lưu refresh token
  Future<void> saveRefreshToken(String token);

  /// Lấy refresh token
  Future<String?> getRefreshToken();

  /// Xóa tất cả auth data
  Future<void> clearAuthData();
}

/// Implementation của AuthLocalDataSource sử dụng SharedPreferences.
class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences sharedPreferences;

  // Keys cho SharedPreferences
  static const String _cachedUserKey = 'CACHED_USER';
  static const String _accessTokenKey = 'ACCESS_TOKEN';
  static const String _refreshTokenKey = 'REFRESH_TOKEN';

  AuthLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void> cacheUser(UserModel user) async {
    try {
      final userJson = json.encode(user.toJson());
      await sharedPreferences.setString(_cachedUserKey, userJson);
    } catch (e) {
      throw CacheException(
        message: 'Không thể lưu thông tin user: ${e.toString()}',
      );
    }
  }

  @override
  Future<UserModel?> getCachedUser() async {
    try {
      final userJsonString = sharedPreferences.getString(_cachedUserKey);
      
      if (userJsonString == null) {
        return null;
      }

      final userJson = json.decode(userJsonString) as Map<String, dynamic>;
      return UserModel.fromJson(userJson);
    } catch (e) {
      throw CacheException(
        message: 'Không thể đọc thông tin user: ${e.toString()}',
      );
    }
  }

  @override
  Future<void> clearCachedUser() async {
    try {
      await sharedPreferences.remove(_cachedUserKey);
    } catch (e) {
      throw CacheException(
        message: 'Không thể xóa thông tin user: ${e.toString()}',
      );
    }
  }

  @override
  Future<void> saveAccessToken(String token) async {
    try {
      await sharedPreferences.setString(_accessTokenKey, token);
    } catch (e) {
      throw CacheException(
        message: 'Không thể lưu access token: ${e.toString()}',
      );
    }
  }

  @override
  Future<String?> getAccessToken() async {
    try {
      return sharedPreferences.getString(_accessTokenKey);
    } catch (e) {
      throw CacheException(
        message: 'Không thể đọc access token: ${e.toString()}',
      );
    }
  }

  @override
  Future<void> saveRefreshToken(String token) async {
    try {
      await sharedPreferences.setString(_refreshTokenKey, token);
    } catch (e) {
      throw CacheException(
        message: 'Không thể lưu refresh token: ${e.toString()}',
      );
    }
  }

  @override
  Future<String?> getRefreshToken() async {
    try {
      return sharedPreferences.getString(_refreshTokenKey);
    } catch (e) {
      throw CacheException(
        message: 'Không thể đọc refresh token: ${e.toString()}',
      );
    }
  }

  @override
  Future<void> clearAuthData() async {
    try {
      await Future.wait([
        sharedPreferences.remove(_cachedUserKey),
        sharedPreferences.remove(_accessTokenKey),
        sharedPreferences.remove(_refreshTokenKey),
      ]);
    } catch (e) {
      throw CacheException(
        message: 'Không thể xóa auth data: ${e.toString()}',
      );
    }
  }
}
