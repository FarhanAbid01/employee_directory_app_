import 'package:equatable/equatable.dart';

class Employee extends Equatable {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String? avatar;

  const Employee({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.avatar,
  });

  @override
  List<Object?> get props => [id, name, email, phone, avatar];
} 