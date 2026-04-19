import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_models/employee_state.dart';
import 'employee_detail.dart';
import 'create_employee.dart';
import 'update_employee.dart';

class EmployeeListScreen extends StatefulWidget {
  const EmployeeListScreen({Key? key}) : super(key: key);

  @override
  State<EmployeeListScreen> createState() => _EmployeeListScreenState();
}

class _EmployeeListScreenState extends State<EmployeeListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<EmployeeState>().fetchEmployees();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Employees'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CreateEmployeeScreen()),
              );
            },
          )
        ],
      ),
      body: Consumer<EmployeeState>(
        builder: (context, state, child) {
          if (state.status == EmployeeStateStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.status == EmployeeStateStatus.error) {
            return Center(child: Text(state.errorMessage ?? 'An error occurred'));
          }
          if (state.employees.isEmpty) {
            return const Center(child: Text('No employees found'));
          }

          return ListView.builder(
            itemCount: state.employees.length,
            itemBuilder: (context, index) {
              final employee = state.employees[index];
              return ListTile(
                title: Text(employee.name ?? 'Unknown'),
                subtitle: Text(employee.email ?? ''),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => UpdateEmployeeScreen(employee: employee),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () async {
                        if (employee.id != null) {
                           final success = await context.read<EmployeeState>().deleteEmployee(employee.id!);
                           if (mounted) {
                             if (success) {
                               ScaffoldMessenger.of(context).showSnackBar(
                                 const SnackBar(content: Text('Employee deleted')),
                               );
                             } else {
                               ScaffoldMessenger.of(context).showSnackBar(
                                 SnackBar(content: Text(context.read<EmployeeState>().errorMessage ?? 'Failed to delete')),
                               );
                             }
                           }
                        }
                      },
                    ),
                  ],
                ),
                onTap: () {
                  if (employee.id != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EmployeeDetailScreen(employeeId: employee.id!),
                      ),
                    );
                  }
                },
              );
            },
          );
        },
      ),
    );
  }
}
