import '../../apiService.dart';

class EmployeeApi {
  final ApiService _apiService = ApiService();

  Future<List<dynamic>> getAllEmployees() async {
    try {
      final response = await _apiService.get('Employees/GetAllEmployee');
      if (response.statusCode == 200) {
        return response.data; // Assuming response.data is a list
      }
      return [];
    } catch (e) {
      throw Exception('Failed to load employees: $e');
    }
  }

  Future<Map<String, dynamic>> getEmployeeById(int id) async {
    try {
      final response = await _apiService.get('Employees/$id');
      if (response.statusCode == 200) {
        return response.data;
      }
      throw Exception('Employee not found');
    } catch (e) {
      throw Exception('Failed to load employee details: $e');
    }
  }

  Future<void> createEmployee(Map<String, dynamic> employeeData) async {
    try {
      final response = await _apiService.post('Employees/CreateEmployee', employeeData);
      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Failed to create employee');
      }
    } catch (e) {
      throw Exception('Failed to create employee: $e');
    }
  }

  Future<void> updateEmployee(int id, Map<String, dynamic> updatedData) async {
    try {
      final response = await _apiService.patch('Employees/UpdateEmployee/$id', updatedData);
      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Failed to update employee');
      }
    } catch (e) {
      throw Exception('Failed to update employee: $e');
    }
  }

  Future<void> deleteEmployee(int id) async {
    try {
      final response = await _apiService.delete('Employees/DeleteEmployee/$id');
      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Failed to delete employee');
      }
    } catch (e) {
      throw Exception('Failed to delete employee: $e');
    }
  }
}
