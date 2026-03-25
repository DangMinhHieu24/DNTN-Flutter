import '../../domain/entities/user_entity.dart';

/// Data Model cho User - chịu trách nhiệm serialize/deserialize JSON.
/// Kế thừa từ UserEntity để đảm bảo tính nhất quán với Domain Layer.
class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.name,
    required super.phone,
    super.email,
    super.avatarUrl,
    super.createdAt,
  });

  /// Factory constructor để tạo UserModel từ JSON (API response)
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      email: json['email']?.toString(),
      avatarUrl: json['avatar_url']?.toString() ?? json['avatarUrl']?.toString(),
      createdAt: json['created_at'] != null 
          ? DateTime.tryParse(json['created_at'].toString())
          : (json['createdAt'] != null 
              ? DateTime.tryParse(json['createdAt'].toString())
              : null),
    );
  }

  /// Convert UserModel thành JSON để gửi lên API hoặc lưu cache
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'email': email,
      'avatar_url': avatarUrl,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  /// Convert từ Entity sang Model (khi cần serialize)
  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      id: entity.id,
      name: entity.name,
      phone: entity.phone,
      email: entity.email,
      avatarUrl: entity.avatarUrl,
      createdAt: entity.createdAt,
    );
  }

  /// Convert sang Entity (để trả về Domain Layer)
  UserEntity toEntity() {
    return UserEntity(
      id: id,
      name: name,
      phone: phone,
      email: email,
      avatarUrl: avatarUrl,
      createdAt: createdAt,
    );
  }

  /// CopyWith method để tạo bản sao với một số field thay đổi
  UserModel copyWith({
    String? id,
    String? name,
    String? phone,
    String? email,
    String? avatarUrl,
    DateTime? createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
