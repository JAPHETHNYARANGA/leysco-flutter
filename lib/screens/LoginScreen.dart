import 'package:flutter/material.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import '../services/ApiService.dart';
import '../widgets/CustomButtom.dart';
import '../widgets/CustomInput.dart';
import 'Homepage.dart';
import 'RegisterScreen.dart';


class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final ApiService _apiService = ApiService();
  late ProgressDialog _progressDialog;

  @override
  void initState() {
    super.initState();
    _progressDialog = ProgressDialog(context);
    _progressDialog.style(
      message: 'Please wait...',
      progressWidget: CircularProgressIndicator(),
    );
  }

  void _loginUser() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    try {
      await _progressDialog.show();
      var response = await _apiService.login(email, password);
      await _progressDialog.hide();

      // Handle successful login response
      print('Login Success: ${response.message}');
      // Navigate to home page or perform other actions
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } catch (error) {
      await _progressDialog.hide();
      // Handle login failure (optional)
      print('Login Error: $error');
      // You can show an error message or perform other actions here
    }
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
              text: 'Login',
              onPressed: _loginUser, // Call _loginUser method on button press
            ),
            SizedBox(height: 20.0),
            GestureDetector(
              onTap: () {
                // Navigate to Registration screen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegisterScreen()),
                );
              },
              child: const Center(
                child: Text(
                  "User Register",
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