import 'package:dartz/dartz.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../../domain/entities/employee.dart';
import '../../domain/repositories/employee_repository.dart';
import '../../core/error/failures.dart';
import '../datasources/employee_remote_data_source.dart';
import '../datasources/employee_local_data_source.dart';
import '../models/employee_model.dart';

class EmployeeRepositoryImpl implements EmployeeRepository {
  final EmployeeRemoteDataSource remoteDataSource;
  final EmployeeLocalDataSource localDataSource;
  final Connectivity connectivity;

  EmployeeRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.connectivity,
  });

  @override
  Future<Either<Failure, List<Employee>>> getEmployees() async {
    try {
      final connectivityResult = await connectivity.checkConnectivity();
      
      if (connectivityResult == ConnectivityResult.none) {
        // No internet connection, get from local storage
        final localEmployees = await localDataSource.getEmployees();
        return Right(localEmployees);
      } else {
        // Internet available, fetch from API
        final remoteEmployees = await remoteDataSource.getEmployees();
        // Cache the data locally
        await localDataSource.cacheEmployees(remoteEmployees);
        return Right(remoteEmployees);
      }
    } catch (e) {
      // If remote fails, try to get from local storage
      try {
        final localEmployees = await localDataSource.getEmployees();
        return Right(localEmployees);
      } catch (localError) {
        return Left(ServerFailure('Failed to fetch employees: $e'));
      }
    }
  }

  @override
  Future<Either<Failure, Employee>> createEmployee(Employee employee) async {
    try {
      final connectivityResult = await connectivity.checkConnectivity();
      
      if (connectivityResult == ConnectivityResult.none) {
        return const Left(NetworkFailure('No internet connection'));
      }

      final employeeModel = EmployeeModel.fromEntity(employee);
      final createdEmployee = await remoteDataSource.createEmployee(employeeModel);
      
      // Also save to local storage
      await localDataSource.addEmployee(createdEmployee);
      
      return Right(createdEmployee);
    } catch (e) {
      return const Left(ServerFailure('Failed to create employee'));
    }
  }
} 