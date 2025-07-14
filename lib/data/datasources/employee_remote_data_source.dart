import '../../core/network/api_client.dart';
import '../../core/constants/api_constants.dart';
import '../models/employee_model.dart';

abstract class EmployeeRemoteDataSource {
  Future<List<EmployeeModel>> getEmployees();
  Future<EmployeeModel> createEmployee(EmployeeModel employee);
}

class EmployeeRemoteDataSourceImpl implements EmployeeRemoteDataSource {
  final ApiClient apiClient;

  EmployeeRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<EmployeeModel>> getEmployees() async {
    try {
      final response = await apiClient.get(ApiConstants.usersEndpoint);
      
      if (response.containsKey('data') && response['data'] is List) {
        final List<dynamic> employeesJson = response['data'];
        return employeesJson
            .map((json) => EmployeeModel.fromJson(json))
            .toList();
      } else {
        throw Exception('Invalid response format');
      }
    } catch (e) {
      throw Exception('Failed to fetch employees: $e');
    }
  }

  @override
  Future<EmployeeModel> createEmployee(EmployeeModel employee) async {
    try {
      final response = await apiClient.post(
        ApiConstants.createUserEndpoint,
        employee.toJson(),
      );
      
      if (response.containsKey('id')) {
        // The API returns the created employee with an ID
        return EmployeeModel.fromJson(response);
      } else {
        throw Exception('Invalid response format for created employee');
      }
    } catch (e) {
      throw Exception('Failed to create employee: $e');
    }
  }
} 