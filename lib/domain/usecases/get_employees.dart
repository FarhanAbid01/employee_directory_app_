import 'package:dartz/dartz.dart';
import '../entities/employee.dart';
import '../repositories/employee_repository.dart';
import '../../core/error/failures.dart';

class GetEmployees {
  final EmployeeRepository repository;

  GetEmployees(this.repository);

  Future<Either<Failure, List<Employee>>> call() async {
    return await repository.getEmployees();
  }
} 