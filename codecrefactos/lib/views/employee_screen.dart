import 'package:codecrefactos/widgets/appbar.dart';
import 'package:codecrefactos/viewmodels/employee_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/employee_card.dart';

class EmployeesScreen extends StatelessWidget {
  const EmployeesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<EmployeesViewModel>(context);

    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      appBar: Appbar(
        onAdd: () {},
        onLogout: () {
          print("Logout Pressed");
        },
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Employee Management",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "Add, edit, and manage employees",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 16),

            TextField(
              onChanged: vm.searchEmployees,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: "Search employees...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
            const SizedBox(height: 16),

            Expanded(
              child: ListView.builder(
                itemCount: vm.filteredEmployees.length,
                itemBuilder: (context, index) {
                  return EmployeeCard(
                    employee: vm.filteredEmployees[index],
                    onDelete: () => vm.deleteEmployee(index),
                    onToggleStatus: () => vm.toggleStatus(index),
                    onEdit: () {},
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
