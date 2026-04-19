import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_models/employee_state.dart';

class EmployeeDetailScreen extends StatefulWidget {
  final int employeeId;

  const EmployeeDetailScreen({Key? key, required this.employeeId}) : super(key: key);

  @override
  State<EmployeeDetailScreen> createState() => _EmployeeDetailScreenState();
}

class _EmployeeDetailScreenState extends State<EmployeeDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<EmployeeState>().fetchEmployeeById(widget.employeeId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Employee Details'),
      ),
      body: Consumer<EmployeeState>(
        builder: (context, state, child) {
          if (state.status == EmployeeStateStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.status == EmployeeStateStatus.error) {
            return Center(child: Text(state.errorMessage ?? 'An error occurred'));
          }

          final employee = state.selectedEmployee;
          if (employee == null) {
            return const Center(child: Text('Employee not found.'));
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                _buildDetailRow('Name', employee.name),
                _buildDetailRow('Email', employee.email),
                _buildDetailRow('Phone', employee.phone),
                _buildDetailRow('Position', employee.position),
                _buildDetailRow('Department', employee.department),
                _buildDetailRow('Salary', employee.salary?.toString()),
                _buildDetailRow('Status', employee.status == true ? 'Active' : 'Inactive'),
                _buildDetailRow('Join Date', employee.joinDate),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDetailRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          Expanded(child: Text(value ?? 'N/A', style: const TextStyle(fontSize: 16))),
        ],
      ),
    );
  }
}
