import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/employee.dart';
import '../view_models/employee_state.dart';

class UpdateEmployeeScreen extends StatefulWidget {
  final Employee employee;

  const UpdateEmployeeScreen({Key? key, required this.employee}) : super(key: key);

  @override
  State<UpdateEmployeeScreen> createState() => _UpdateEmployeeScreenState();
}

class _UpdateEmployeeScreenState extends State<UpdateEmployeeScreen> {
  final _formKey = GlobalKey<FormState>();
  late Map<String, dynamic> _formData;

  @override
  void initState() {
    super.initState();
    _formData = {
      'name': widget.employee.name,
      'email': widget.employee.email,
      'phone': widget.employee.phone,
      'position': widget.employee.position,
      'department': widget.employee.department,
      'salary': widget.employee.salary,
    };
  }

  void _submit() async {
    if (_formKey.currentState!.validate() && widget.employee.id != null) {
      _formKey.currentState!.save();
      
      final state = context.read<EmployeeState>();
      final success = await state.updateEmployee(widget.employee.id!, _formData);
      
      if (!mounted) return;
      
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Employee updated successfully')),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(state.errorMessage ?? 'Failed to update employee')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<EmployeeState>().status == EmployeeStateStatus.loading;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Employee'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                initialValue: _formData['name'],
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) => value == null || value.isEmpty ? 'Required' : null,
                onSaved: (value) => _formData['name'] = value,
              ),
              TextFormField(
                initialValue: _formData['email'],
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) => value == null || value.isEmpty ? 'Required' : null,
                onSaved: (value) => _formData['email'] = value,
              ),
              TextFormField(
                initialValue: _formData['phone'],
                decoration: const InputDecoration(labelText: 'Phone'),
                onSaved: (value) => _formData['phone'] = value,
              ),
              TextFormField(
                initialValue: _formData['position'],
                decoration: const InputDecoration(labelText: 'Position'),
                onSaved: (value) => _formData['position'] = value,
              ),
              DropdownButtonFormField<String>(
                initialValue: ["Sales", "Purchasing", "Warehouse", "Technical", "Management"].contains(_formData['department']) ? _formData['department'] : null,
                decoration: const InputDecoration(labelText: 'Department'),
                items: ["Sales", "Purchasing", "Warehouse", "Technical", "Management"]
                    .map((dept) => DropdownMenuItem(value: dept, child: Text(dept)))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _formData['department'] = value;
                  });
                },
                onSaved: (value) => _formData['department'] = value,
              ),
              TextFormField(
                initialValue: _formData['salary']?.toString(),
                decoration: const InputDecoration(labelText: 'Salary'),
                keyboardType: TextInputType.number,
                onSaved: (value) => _formData['salary'] = double.tryParse(value ?? ''),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: isLoading ? null : _submit,
                child: isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Update'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
