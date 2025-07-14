part of 'employee_bloc.dart';

enum EmployeeStatus {
  initial,
  loading,
  loaded,
  error,
  addError,
  addSuccess  // New status for successful add
}

class EmployeeState extends Equatable {
  final EmployeeStatus status;
  final List<Employee> employees;
  final String? errorMessage;

  const EmployeeState({
    this.status = EmployeeStatus.initial,
    this.employees = const [],
    this.errorMessage,
  });

  EmployeeState copyWith({
    EmployeeStatus? status,
    List<Employee>? employees,
    String? errorMessage,
  }) {
    return EmployeeState(
      status: status ?? this.status,
      employees: employees ?? this.employees,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, employees, errorMessage];
} 