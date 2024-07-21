import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/LoginResponse.dart';
import '../models/TaskResponse.dart';
import '../services/ApiService.dart'; // Import your ApiService
import 'LoginScreen.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ApiService _apiService = ApiService();
  List<Task> tasks = [];
  List<User> users = []; // List to hold fetched users

  @override
  void initState() {
    super.initState();
    _fetchTasks();
  }

  Future<void> _fetchTasks() async {
    try {
      List<Task> fetchedTasks = await _apiService.fetchTasks();
      setState(() {
        tasks = fetchedTasks;
      });

      // Log fetched tasks
      print('Fetched Tasks:');
      tasks.forEach((task) {
        print('Task Name: ${task.name}');
        print('Assigned To: ${task.assignedUser ?? "Unassigned"}');
        print('Status: ${task.status}');
        print('---');
      });
    } catch (e) {
      print('Error fetching tasks: $e');
      // Handle error, show snackbar, etc.
    }
  }

  Future<void> _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('authToken'); // Remove authToken from SharedPreferences

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  Future<void> _startTask(Task task) async {
    try {
      await _apiService.startTask(task.id);
      await _fetchTasks(); // Refresh task list after modification
    } catch (e) {
      print('Error starting task: $e');
      // Handle error, show snackbar, etc.
    }
  }

  Future<void> _completeTask(Task task) async {
    try {
      await _apiService.completeTask(task.id);
      await _fetchTasks(); // Refresh task list after modification
    } catch (e) {
      print('Error completing task: $e');
      // Handle error, show snackbar, etc.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo List'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _logout, // Call _logout method when logout button is pressed
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: Text('Logout'),
              leading: Icon(Icons.logout),
              onTap: _logout, // Call _logout method when logout item in drawer is tapped
            ),
          ],
        ),
      ),
      body: ListView(
        children: [
          _buildTaskList('pending'),
          _buildTaskList('in-progress'),
          _buildTaskList('completed'),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddTaskModal(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildTaskList(String status) {
    List<Task> filteredTasks = tasks.where((task) => task.status == status).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            _getStatusString(status),
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: filteredTasks.length,
          itemBuilder: (context, index) {
            Task task = filteredTasks[index];
            return ListTile(
              title: Text(task.name),
              subtitle: Text('Assigned to: ${task.assignedUser ?? "Unassigned"}'),
              trailing: PopupMenuButton<String>(
                itemBuilder: (context) => [
                  if (status == 'pending')
                    const PopupMenuItem<String>(
                      value: 'Start',
                      child: Text('Start'),
                    ),
                  if (status == 'in-progress')
                    const PopupMenuItem<String>(
                      value: 'Complete',
                      child: Text('Complete'),
                    ),
                  const PopupMenuItem<String>(
                    value: 'Delete',
                    child: Text('Delete'),
                  ),
                ],
                onSelected: (value) async {
                  if (value == 'Start') {
                    await _startTask(task);
                  } else if (value == 'Complete') {
                    await _completeTask(task);
                  } else if (value == 'Delete') {
                    // Call method to delete task
                    await _apiService.deleteTask(task.id);
                    _fetchTasks();
                  }
                },
              ),
            );
          },
        ),
      ],
    );
  }

  String _getStatusString(String status) {
    switch (status) {
      case 'in-progress':
        return 'In Progress';
      case 'pending':
        return 'Pending';
      case 'completed':
        return 'Completed';
      default:
        return '';
    }
  }

  void _showAddTaskModal(BuildContext context) async {
    try {
      users = await _apiService.fetchUsers(); // Fetch users asynchronously
    } catch (e) {
      print('Error fetching users: $e');
      // Handle error, show snackbar, etc.
      return;
    }

    // Controller for task name input
    TextEditingController taskNameController = TextEditingController();

    // Selected user ID for assigning the task
    int? selectedUserId;

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              padding: EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Add Task',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: taskNameController,
                    decoration: InputDecoration(
                      labelText: 'Task Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 16),
                  DropdownButtonFormField<int>(
                    value: selectedUserId,
                    items: users.map((User user) {
                      return DropdownMenuItem<int>(
                        value: user.id,
                        child: Text(user.name),
                      );
                    }).toList(),
                    onChanged: (int? value) {
                      setState(() {
                        selectedUserId = value;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Assign To',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          Map<String, dynamic> taskData = {
                            'name': taskNameController.text,
                            'assigned_user_id': selectedUserId,
                          };
                          try {
                            await _apiService.createTask(taskData);
                            Navigator.pop(context); // Close the modal on success
                            _fetchTasks(); // Refresh task list after adding new task
                          } catch (e) {
                            print('Error creating task: $e');
                            // Handle error, show snackbar, etc.
                          }
                        },
                        child: Text('Add Task'),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
