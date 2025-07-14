import 'package:hive_ce/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/employee.dart';

part 'employee_model.g.dart';

@HiveType(typeId: 0)
@JsonSerializable()
class EmployeeModel extends Employee {
  @HiveField(0)
  @override
  final int id;

  @HiveField(1)
  @override
  final String name;

  @HiveField(2)
  @override
  final String email;

  @HiveField(3)
  @override
  final String phone;

  @HiveField(4)
  @override
  final String? avatar;

  const EmployeeModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.avatar,
  }) : super(
          id: id,
          name: name,
          email: email,
          phone: phone,
          avatar: avatar,
        );

  factory EmployeeModel.fromJson(Map<String, dynamic> json) =>
      _$EmployeeModelFromJson(json);

  Map<String, dynamic> toJson() => _$EmployeeModelToJson(this);

  factory EmployeeModel.fromEntity(Employee employee) {
    return EmployeeModel(
      id: employee.id,
      name: employee.name,
      email: employee.email,
      phone: employee.phone,
      avatar: employee.avatar,
    );
  }
} 