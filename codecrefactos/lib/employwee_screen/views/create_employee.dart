import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_models/employee_state.dart';

class CreateEmployeeScreen extends StatefulWidget {
  const CreateEmployeeScreen({Key? key}) : super(key: key);

  @override
  State<CreateEmployeeScreen> createState() => _CreateEmployeeScreenState();
}

class _CreateEmployeeScreenState extends State<CreateEmployeeScreen> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _formData = {};

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      
      final state = context.read<EmployeeState>();
      final success = await state.createEmployee(_formData);
      
      if (!mounted) return;
      
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Employee created successfully')),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(state.errorMessage ?? 'Failed to create employee')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<EmployeeState>().status == EmployeeStateStatus.loading;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Employee'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) => value == null || value.isEmpty ? 'Required' : null,
                onSaved: (value) => _formData['name'] = value,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) => value == null || value.isEmpty ? 'Required' : null,
                onSaved: (value) => _formData['email'] = value,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Phone'),
                onSaved: (value) => _formData['phone'] = value,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Position'),
                onSaved: (value) => _formData['position'] = value,
              ),
              DropdownButtonFormField<String>(
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
                decoration: const InputDecoration(labelText: 'Salary'),
                keyboardType: TextInputType.number,
                onSaved: (value) => _formData['salary'] = double.tryParse(value ?? ''),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: isLoading ? null : _submit,
                child: isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Create'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
