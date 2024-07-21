import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/LoginResponse.dart';
import '../models/RegisterResponse.dart';
import '../models/TaskResponse.dart';

class ApiService {
  static const String baseUrl = 'https://d954-102-68-76-239.ngrok-free.app/api';

  Future<String?> _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('authToken');
  }

  Future<void> _saveToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('authToken', token);
  }

  Future<LoginResponse> login(String email, String password) async {
    final url = Uri.parse('$baseUrl/login');
    final response = await http.post(
      url,
      body: {
        'email': email,
        'password': password,
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      String token = responseData['token'];
      await _saveToken(token); // Save token to shared preferences
      return LoginResponse.fromJson(responseData);
    } else {
      throw Exception('Failed to login');
    }
  }

  Future<RegisterResponse> register(String name, String email, String password) async {
    final url = Uri.parse('$baseUrl/register');
    final response = await http.post(
      url,
      body: {
        'name': name,
        'email': email,
        'password': password,
      },
    );

    if (response.statusCode == 201) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      return RegisterResponse.fromJson(responseData);
    } else {
      throw Exception('Failed to register');
    }
  }

  Future<List<Task>> fetchTasks() async {
    final url = Uri.parse('$baseUrl/tasks');

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer ${await _getToken()}',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);
        List<Task> tasks = responseData.map((data) => Task.fromJson(data)).toList();
        return tasks;
      } else {
        print('Error fetching tasks: ${response.statusCode}');
        print('Response Body: ${response.body}');
        throw Exception('Failed to load tasks');
      }
    } catch (e) {
      print('Exception during fetchTasks: $e');
      throw Exception('Failed to load tasks');
    }
  }

  Future<List<User>> fetchUsers() async {
    final url = Uri.parse('$baseUrl/users');

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer ${await _getToken()}',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body)['user'];
        List<User> users = responseData.map((data) => User.fromJson(data)).toList();
        return users;
      } else {
        print('Error fetching users: ${response.statusCode}');
        print('Response Body: ${response.body}');
        throw Exception('Failed to load users');
      }
    } catch (e) {
      print('Exception during fetchUsers: $e');
      throw Exception('Failed to load users');
    }
  }

  Future<void> createTask(Map<String, dynamic> taskData) async {
    final url = Uri.parse('$baseUrl/create');

    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer ${await _getToken()}',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(taskData),
      );

      print('Error creating task: ${response.statusCode}');
      print('Response Body: ${response.body}');


      if (response.statusCode == 201) {
        print('Task created successfully');
      } else {
        print('Error creating task: ${response.statusCode}');
        print('Response Body: ${response.body}');
        throw Exception('Failed to create task');
      }
    } catch (e) {
      print('Exception during createTask: $e');
      throw Exception('Failed to create task');
    }
  }

  Future<void> deleteTask(int taskId) async {
    final url = Uri.parse('$baseUrl/tasks/$taskId');

    try {
      final response = await http.delete(
        url,
        headers: {
          'Authorization': 'Bearer ${await _getToken()}',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        print('Task deleted successfully');
      } else {
        print('Error deleting task: ${response.statusCode}');
        print('Response Body: ${response.body}');
        throw Exception('Failed to delete task');
      }
    } catch (e) {
      print('Exception during deleteTask: $e');
      throw Exception('Failed to delete task');
    }
  }

  Future<void> startTask(int taskId) async {
    final url = Uri.parse('$baseUrl/tasks/$taskId/start');

    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer ${await _getToken()}',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        print('Task started successfully');
      } else {
        print('Error starting task: ${response.statusCode}');
        print('Response Body: ${response.body}');
        throw Exception('Failed to start task');
      }
    } catch (e) {
      print('Exception during startTask: $e');
      throw Exception('Failed to start task');
    }
  }

  Future<void> completeTask(int taskId) async {
    final url = Uri.parse('$baseUrl/tasks/$taskId/complete');

    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer ${await _getToken()}',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        print('Task completed successfully');
      } else {
        print('Error completing task: ${response.statusCode}');
        print('Response Body: ${response.body}');
        throw Exception('Failed to complete task');
      }
    } catch (e) {
      print('Exception during completeTask: $e');
      throw Exception('Failed to complete task');
    }
  }
}
