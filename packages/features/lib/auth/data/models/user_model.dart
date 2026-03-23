import '../../domain/entities/user.dart';

/// User Model - Chuyển đổi giữa JSON và Entity
/// Extends từ User entity để kế thừa properties
class UserModel extends User {
  const UserModel({
    required super.id,
    required super.name,
    required super.phone,
    super.email,
    required super.createdAt,
  });

  /// Tạo UserModel từ JSON (từ API response)
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      phone: json['phone'] as String,
      email: json['email'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  /// Chuyển UserModel thành JSON (để gửi lên API)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'email': email,
      'created_at': createdAt.toIso8601String(),
    };
  }

  /// Tạo UserModel từ User entity
  factory UserModel.fromEntity(User user) {
    return UserModel(
      id: user.id,
      name: user.name,
      phone: user.phone,
      email: user.email,
      createdAt: user.createdAt,
    );
  }

  /// Copy with method để tạo instance mới với một số field thay đổi
  UserModel copyWith({
    String? id,
    String? name,
    String? phone,
    String? email,
    DateTime? createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
