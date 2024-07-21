import 'package:flutter/material.dart';
import 'package:leysco/screens/LoginScreen.dart';

import '../services/ApiService.dart';
import '../widgets/CustomButtom.dart';
import '../widgets/CustomInput.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final ApiService _apiService = ApiService();


  void _registerUser() {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    String name = _nameController.text.trim();

    _apiService.register( name,email, password).then((response) {
      // Handle successful login response
      print('Login Success: ${response}');
      // Navigate to home page or perform other actions
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    }).catchError((error) {
      // Handle login failure (optional)
      print('Login Error: $error');
      // You can show an error message or perform other actions here
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomInput(
              controller: _nameController,
              labelText: 'Name',
              hintText: 'Enter your Name',
              keyboardType: TextInputType.text,
            ),
            SizedBox(height: 20.0),
            CustomInput(
              controller: _emailController,
              labelText: 'Email',
              hintText: 'Enter your email',
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 20.0),
            CustomInput(
              controller: _passwordController,
              labelText: 'Password',
              hintText: 'Enter your password',
              obscureText: true,
            ),
            SizedBox(height: 20.0),
            CustomButton(
              text: 'Register',
              onPressed: _registerUser,
            ),

            SizedBox(height: 20.0,),

            GestureDetector(
              onTap: () {
                // Navigate to Registration screen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
              child: const Center(
                child: Text(
                  "Login",
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
