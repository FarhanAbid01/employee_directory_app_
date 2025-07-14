import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:hive_ce/hive.dart';


import '../../data/models/employee_model.dart';
import '../../data/datasources/employee_remote_data_source.dart';
import '../../data/datasources/employee_local_data_source.dart';
import '../../data/repositories/employee_repository_impl.dart';

import '../../domain/usecases/get_employees.dart';
import '../../domain/usecases/create_employee.dart';
import '../../presentation/bloc/employee_bloc.dart';
import '../network/api_client.dart';
import '../utils/hive_init.dart';

class InjectionContainer {
  static Future<void> init() async {
    // Initialize Hive
    await HiveInit.init();
    
    // Get Hive box
    final employeesBox = Hive.box<EmployeeModel>(HiveInit.employeesBoxName);
    
    // Core
    final apiClient = ApiClient(client: http.Client());
    final connectivity = Connectivity();
    
    // Data sources
    final employeeRemoteDataSource = EmployeeRemoteDataSourceImpl(
      apiClient: apiClient,
    );
    final employeeLocalDataSource = EmployeeLocalDataSourceImpl(
      employeesBox: employeesBox as Box<EmployeeModel>,
    );
    
    // Repository
    final employeeRepository = EmployeeRepositoryImpl(
      remoteDataSource: employeeRemoteDataSource,
      localDataSource: employeeLocalDataSource,
      connectivity: connectivity,
    );
    
    // Use cases
    final getEmployees = GetEmployees(employeeRepository);
    final createEmployee = CreateEmployee(employeeRepository);
    
    // Bloc
    final employeeBloc = EmployeeBloc(
      getEmployees: getEmployees,
      createEmployee: createEmployee,
    );
    
    // Register dependencies
    _registerDependencies(
      employeeBloc: employeeBloc,
    );
  }

  static void _registerDependencies({
    required EmployeeBloc employeeBloc,
  }) {
    // Store bloc instances for access throughout the app
    _employeeBloc = employeeBloc;
  }

  // Singleton instances
  static EmployeeBloc? _employeeBloc;
  
  static EmployeeBloc get employeeBloc {
    if (_employeeBloc == null) {
      throw Exception('Dependencies not initialized. Call InjectionContainer.init() first.');
    }
    return _employeeBloc!;
  }

  static Future<void> dispose() async {
    await HiveInit.close();
  }
} 