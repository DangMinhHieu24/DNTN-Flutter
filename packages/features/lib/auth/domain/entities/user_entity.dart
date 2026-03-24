import 'package:equatable/equatable.dart';

/// Entity đại diện cho người dùng trong Domain Layer.
/// Không phụ thuộc vào bất kỳ framework hay database nào.
class UserEntity extends Equatable {
  final String id;
  final String name;
  final String phone;
  final String? email;
  final String? avatarUrl;
  final DateTime? createdAt;

  const UserEntity({
    required this.id,
    required this.name,
    required this.phone,
    this.email,
    this.avatarUrl,
    this.createdAt,
  });

  @override
  List<Object?> get props => [id, name, phone, email, avatarUrl, createdAt];
}
