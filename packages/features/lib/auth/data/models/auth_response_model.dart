import 'user_model.dart';

/// Model cho response từ API khi đăng nhập/đăng ký thành công.
/// Thường bao gồm user info và access token.
class AuthResponseModel {
  final UserModel user;
  final String accessToken;
  final String? refreshToken;
  final DateTime? expiresAt;

  const AuthResponseModel({
    required this.user,
    required this.accessToken,
    this.refreshToken,
    this.expiresAt,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      user: UserModel.fromJson(json['user'] ?? json['data'] ?? {}),
      accessToken: json['access_token']?.toString() ?? 
                   json['accessToken']?.toString() ?? 
                   json['token']?.toString() ?? '',
      refreshToken: json['refresh_token']?.toString() ?? 
                    json['refreshToken']?.toString(),
      expiresAt: json['expires_at'] != null
          ? DateTime.tryParse(json['expires_at'].toString())
          : (json['expiresAt'] != null
              ? DateTime.tryParse(json['expiresAt'].toString())
              : null),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': user.toJson(),
      'access_token': accessToken,
      'refresh_token': refreshToken,
      'expires_at': expiresAt?.toIso8601String(),
    };
  }
}
