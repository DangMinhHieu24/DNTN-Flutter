import 'package:equatable/equatable.dart';

/// Entity User - Đại diện cho user trong domain layer
/// Không phụ thuộc vào bất kỳ framework nào
class User extends Equatable {
  final String id;
  final String name;
  final String phone;
  final String? email;
  final DateTime createdAt;

  const User({
    required this.id,
    required this.name,
    required this.phone,
    this.email,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, name, phone, email, createdAt];

  @override
  String toString() => 'User(id: $id, name: $name, phone: $phone)';
}
