import 'package:dartz/dartz.dart';
import '../entities/employee.dart';
import '../../core/error/failures.dart';

abstract class EmployeeRepository {
  Future<Either<Failure, List<Employee>>> getEmployees();
  Future<Either<Failure, Employee>> createEmployee(Employee employee);
} 