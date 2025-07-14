import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../bloc/employee_bloc.dart';
import '../widgets/employee_card.dart';
import '../widgets/loading_shimmer.dart';
import '../widgets/error_widget.dart';
import 'add_employee_page.dart';

class EmployeeListPage extends StatelessWidget {
  const EmployeeListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Employee Directory',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blue[600],
        elevation: 0,
      ),
      body: BlocBuilder<EmployeeBloc, EmployeeState>(
        builder: (context, state) {
          // Initial state - load employees
          if (state.status == EmployeeStatus.initial) {
            context.read<EmployeeBloc>().add(LoadEmployees());
            return const LoadingShimmer();
          }

          // Loading state
          if (state.status == EmployeeStatus.loading) {
            return const LoadingShimmer();
          }

          // Error state (only for list errors, not add errors)
          if (state.status == EmployeeStatus.error && state.errorMessage != null) {
            return CustomErrorWidget(
              message: state.errorMessage!,
              onRetry: () {
                context.read<EmployeeBloc>().add(LoadEmployees());
              },
            );
          }

          // Show list for loaded state and ignore add errors
          // This ensures add errors don't affect the list view
          return _buildEmployeeList(context, state.employees);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddEmployeePage(),
            ),
          );
        },
        backgroundColor: Colors.blue[600],
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildEmployeeList(BuildContext context, List<dynamic> employees) {
    if (employees.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.people_outline,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No employees found',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Add your first employee!',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        context.read<EmployeeBloc>().add(LoadEmployees());
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: employees.length,
        itemBuilder: (context, index) {
          final employee = employees[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: EmployeeCard(employee: employee),
          );
        },
      ),
    );
  }
} 