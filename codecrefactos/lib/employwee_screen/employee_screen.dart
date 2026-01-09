import 'package:codecrefactos/employwee_screen/employee_viewmodel.dart';
import 'package:codecrefactos/widgets/empty_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/employee_card.dart';
import '../widgets/appbar.dart';
import '../widgets/bottom_shit_add.dart';

class EmployeesScreen extends StatelessWidget {
  const EmployeesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<EmployeesViewModel>(context);

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: Appbar(
        showLogoutButton: false,
        onAdd: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.white,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            builder: (_) => AddEmployeeSheet(vm: vm),
          );
        },
        onLogout: () {
          print("Logout Pressed");
        },
        bottonTitle: 'Add Employee',
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
              child: vm.filteredEmployees.isEmpty
                  ? const AppEmptyState(
                      icon: Icons.people_outline,
                      title: "No Employees Found",
                      subtitle:
                          "You can add new employees by tapping the button above.",
                    )
                  : ListView.builder(
                      itemCount: vm.filteredEmployees.length,
                      itemBuilder: (context, index) {
                        final emp = vm.filteredEmployees[index];
                        final realIndex = vm.employeesList.indexOf(emp);

                        return EmployeeCard(
                          employee: emp,
                          index: realIndex,
                          onDelete: () => vm.deleteEmployee(realIndex),
                          onToggleStatus: () => vm.toggleStatus(realIndex),
                          onEdit: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.white,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(20),
                                ),
                              ),
                              builder: (_) => AddEmployeeSheet(
                                vm: vm,
                                employee: emp,
                                index: realIndex,
                              ),
                            );
                          },
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
