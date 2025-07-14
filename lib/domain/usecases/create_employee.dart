import 'package:dartz/dartz.dart';
import '../entities/employee.dart';
import '../repositories/employee_repository.dart';
import '../../core/error/failures.dart';

class CreateEmployee {
  final EmployeeRepository repository;

  CreateEmployee(this.repository);

  Future<Either<Failure, Employee>> call(Employee employee) async {
    return await repository.createEmployee(employee);
  }
} 