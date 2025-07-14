import 'package:hive_ce/hive.dart';
import '../models/employee_model.dart';

abstract class EmployeeLocalDataSource {
  Future<List<EmployeeModel>> getEmployees();
  Future<void> cacheEmployees(List<EmployeeModel> employees);
  Future<void> addEmployee(EmployeeModel employee);
  Future<void> clearCache();
}

class EmployeeLocalDataSourceImpl implements EmployeeLocalDataSource {
  static const String employeesBoxName = 'employees';
  final Box<EmployeeModel> employeesBox;

  EmployeeLocalDataSourceImpl({required this.employeesBox});

  @override
  Future<List<EmployeeModel>> getEmployees() async {
    try {
      return employeesBox.values.toList();
    } catch (e) {
      throw Exception('Failed to get employees from cache: $e');
    }
  }

  @override
  Future<void> cacheEmployees(List<EmployeeModel> employees) async {
    try {
      await employeesBox.clear();
      await employeesBox.addAll(employees);
    } catch (e) {
      throw Exception('Failed to cache employees: $e');
    }
  }

  @override
  Future<void> addEmployee(EmployeeModel employee) async {
    try {
      await employeesBox.add(employee);
    } catch (e) {
      throw Exception('Failed to add employee to cache: $e');
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      await employeesBox.clear();
    } catch (e) {
      throw Exception('Failed to clear cache: $e');
    }
  }
} 