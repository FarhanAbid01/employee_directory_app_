import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:dartz/dartz.dart';
import '../../domain/entities/employee.dart';
import '../../domain/usecases/get_employees.dart';
import '../../domain/usecases/create_employee.dart';
import '../../core/error/failures.dart';

part 'employee_event.dart';
part 'employee_state.dart';

class EmployeeBloc extends Bloc<EmployeeEvent, EmployeeState> {
  final GetEmployees getEmployees;
  final CreateEmployee createEmployee;

  EmployeeBloc({
    required this.getEmployees,
    required this.createEmployee,
  }) : super(const EmployeeState()) {
    on<LoadEmployees>(_onLoadEmployees);
    on<AddEmployee>(_onAddEmployee);
  }

  Future<void> _onLoadEmployees(
    LoadEmployees event,
    Emitter<EmployeeState> emit,
  ) async {
    emit(state.copyWith(status: EmployeeStatus.loading));
    
    final result = await getEmployees();
    
    result.fold(
      (failure) => emit(state.copyWith(
        status: EmployeeStatus.error,
        errorMessage: _mapFailureToMessage(failure),
      )),
      (employees) => emit(state.copyWith(
        status: EmployeeStatus.loaded,
        employees: employees,
        errorMessage: null,
      )),
    );
  }

  Future<void> _onAddEmployee(
    AddEmployee event,
    Emitter<EmployeeState> emit,
  ) async {
    // Reset any previous add error state before attempting to add
    if (state.status == EmployeeStatus.addError) {
      emit(state.copyWith(
        status: EmployeeStatus.initial,
        errorMessage: null,
      ));
    }

    final result = await createEmployee(event.employee);
    
    result.fold(
      (failure) => emit(state.copyWith(
        status: EmployeeStatus.addError,
        errorMessage: _mapFailureToMessage(failure),
      )),
      (createdEmployee) {
        // First emit addSuccess to trigger navigation
        emit(state.copyWith(
          status: EmployeeStatus.addSuccess,
          errorMessage: null,
        ));
        // Then reload the list
        add(LoadEmployees());
      },
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return failure.message;
      case NetworkFailure:
        return failure.message;
      case CacheFailure:
        return failure.message;
      default:
        return 'Unexpected error';
    }
  }
} 